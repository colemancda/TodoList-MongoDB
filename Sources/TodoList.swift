/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import TodoListAPI
import MongoKitten


#if os(Linux)
    typealias Valuetype = Any
#else
    typealias Valuetype = AnyObject
#endif

enum Errors: ErrorProtocol {
    case couldNotRetrieveData
    case objectDoesNotExist
    case couldNotUpdate
    case couldNotAddItem
    case couldNotParseData
}
/// TodoList for MongoDB
public class TodoList: TodoListAPI {

    static let defaultMongoHost = "127.0.0.1"
    static let defaultMongoPort = UInt16(5984)
    static let defaultDatabaseName = "todolist"

    let databaseName = "todolist"

    let designName = "tododb"

    let server: Server!

    let collection = "todos"

    /*let connectionProperties = nil
    // Find database if it is already running
    public init(_ dbConfiguration: DatabaseConfiguration) {

        connectionProperties = ConnectionProperties(host: dbConfiguration.host!,
                                                    port: Int16(dbConfiguration.port!),
                                                    secured: true,
                                                    username: dbConfiguration.username,
                                                    password: dbConfiguration.password)

    }*/

    public init(database: String = TodoList.defaultDatabaseName, host: String = TodoList.defaultMongoHost,
                port: UInt16 = TodoList.defaultMongoPort,
                username: String? = nil, password: String? = nil) {

                do {
                    server = try Server("mongodb://username:password@localhost:27017", automatically: true)

                } catch {

                    print("MongoDB is not available on the given host and port")
                    exit(1)

                }

                //let database = server[databaseName]
                //let todosCollection = database[collection]

    }

    public func count(oncompletion: (Int?, ErrorProtocol?) -> Void) {

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let count = try todosCollection.count()

            oncompletion(count, nil)

        } catch {
            oncompletion(nil, error)

        }


    }

    public func count(withUserID: String, oncompletion: (Int?, ErrorProtocol?) -> Void) {

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let query: Query = "userID" == withUserID

            let count = try todosCollection.count(matching: query)

            oncompletion(count, nil)

        } catch {
            oncompletion(nil, error)

        }
    }

    public func clear(oncompletion: (ErrorProtocol?) -> Void) {

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let query: Query = "type" == "todo"

            try todosCollection.remove(matching: query)

            oncompletion(nil)

        } catch {
            oncompletion(nil)

        }
    }

    public func clear(withUserID: String, oncompletion: (ErrorProtocol?) -> Void) {

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let query: Query = "userID" == withUserID

            try todosCollection.remove(matching: query)

            oncompletion(nil)

        } catch {
            oncompletion(nil)

        }
    }

    public func get(oncompletion: ([TodoItem]?, ErrorProtocol?) -> Void ) {

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let items = try todosCollection.find()

            let todoItems = try parseTodoItemList(items)

            oncompletion(todoItems, nil)

        } catch {
            oncompletion(nil, error)

        }

    }

    public func get(withUserID: String, oncompletion: ([TodoItem]?, ErrorProtocol?) -> Void) {

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let query: Query = "userID" == withUserID

            let items = try todosCollection.find(matching: query)

            let todoItems = try parseTodoItemList(items)

            oncompletion(todoItems, nil)

        } catch {
            oncompletion(nil, error)

        }

    }

    public func get(withUserID: String, withDocumentID: String, oncompletion: (TodoItem?, ErrorProtocol?) -> Void ) {

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let id = try ObjectId(withDocumentID)

            let query: Query = "userID" == ~withUserID && "_id" == ~id

            let item = try todosCollection.findOne(matching: query)

            guard let sid = item?["_id"].string,
                     suid = item?["userID"].string,
                   stitle = item?["title"].string,
                   sorder = item?["order"].int,
               scompleted = item?["completed"].bool else {

                   oncompletion(nil, Errors.couldNotRetrieveData)
                   return
               }

            let todoItem = TodoItem(documentID: sid, userID: suid, order: sorder, title: stitle, completed: scompleted)

            oncompletion(todoItem, nil)

        } catch {
            oncompletion(nil, error)

        }

    }

    public func add(userID: String, title: String, order: Int, completed: Bool,
        oncompletion: (TodoItem?, ErrorProtocol?) -> Void ) {

        let todoItem: Document = [
                                    "type": "todo",
                                    "userID": ~userID,
                                    "title": ~title,
                                    "order": ~order,
                                    "completed": ~completed
        ]

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let item = try todosCollection.insert(todoItem)

            let todoItem = TodoItem(documentID: item["_id"].string, userID: userID, order: order, title: title, completed: completed)

            oncompletion(todoItem, nil)

        } catch {
            oncompletion(nil, error)

        }

    }

    public func update(documentID: String, userID: String?, title: String?, order: Int?,
        completed: Bool?, oncompletion: (TodoItem?, ErrorProtocol?) -> Void ) {

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let id = try ObjectId(documentID)

            let item = try todosCollection.findOne(matching: ["_id": ~id])

            if let object = item {
                let updatedTodo: Document = [
                                   "type": "todo",
                                   "userID": userID != nil ? ~userID! : ~object["userID"].string,
                                   "title": title != nil ? ~title! : ~object["title"].string,
                                   "order": order != nil ? ~order! : ~object["order"].int,
                                   "completed": completed != nil ? ~completed! : ~object["completed"].bool
                ]

                do {
                    let id = try ObjectId(documentID)

                    try todosCollection.update(matching: ["_id": ~id], to: updatedTodo)

                    let todoItem = TodoItem(documentID: documentID,
                                                userID: updatedTodo["userID"].string,
                                                 order: updatedTodo["order"].int,
                                                 title: updatedTodo["title"].string,
                                             completed: updatedTodo["completed"].bool)

                    oncompletion(todoItem, nil)

                } catch {
                    oncompletion(nil, error)

                }
            }

        } catch {
            oncompletion(nil, error)

        }
    }

    public func delete(withUserID: String, withDocumentID: String, oncompletion: (ErrorProtocol?) -> Void) {

        let database = server[databaseName]
        let todosCollection = database[collection]

        do {
            let id = try ObjectId(withDocumentID)

            try todosCollection.remove(matching: ["_id": ~id])

            oncompletion(nil)

        } catch {
            oncompletion(error)

        }

    }

    public func parseTodoItemList(_ document: Cursor<Document>) throws -> [TodoItem] {

        let todos: [TodoItem] = Array(document).flatMap {
            doc in

            let id = doc["_id"].string
            let userID = doc["userID"].string
            let title = doc["title"].string
            let completed = doc["completed"].bool
            let order = doc["order"].int

            return TodoItem(documentID: id, userID: userID, order: order, title: title, completed: completed)

        }

        return todos
    }

}
