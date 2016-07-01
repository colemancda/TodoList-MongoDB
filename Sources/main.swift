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

import Kitura
import Foundation
import TodoListWeb

let config = Configuration.sharedInstance
config.loadCloudFoundry()

let todos: TodoList

if let dbConfig = config.databaseConfiguration {
    todos = TodoList(dbConfig)
} else {
    todos = TodoList()
}

let router = Router()

let controller = TodoListController(backend: todos)
print(config.port)
Kitura.addHTTPServer(onPort: config.port, with: controller.router)
Kitura.run()
