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
 */

import Foundation
import CloudFoundryEnv
import SwiftyJSON

import LoggerAPI

import TodoListAPI

extension DatabaseConfiguration {

    init(withService: Service) {

        if let credentials = withService.credentials {
            self.host = credentials["uri"].stringValue
            self.username = credentials["username"].stringValue
            self.password = credentials["password"].stringValue
            self.port = UInt16(credentials["port"].stringValue)!
        } else {
            self.host = "127.0.0.1"
            self.username = nil
            self.password = nil
            self.port = UInt16(27017)
        }
        self.options = [String : AnyObject]()
    }
}

public func loadMongoService() {
    do {
        let service = try CloudFoundryEnv.getAppEnv().getService(spec: "TodoList MongoDB")
        Log.verbose("Found TodoList-MongoDB on CloudFoundry")
        print(service)
    }
    catch {

        }
}
