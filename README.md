# Todolist MongoDB

Todolist implemented for Cloudant (MongoDB) backend

Quick start:

- Download the [Swift DEVELOPMENT 06-06 snapshot](https://swift.org/download/#snapshots)
- Download MongoDB

  You can use `brew install mongodb` If you are using mongodb for the first time create the directory to which the mongod process will write data
  `mkdir -p /data/db`

  More information can be found [here](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/)

  Additionally, you can view the database' shell with `mongo`

- Clone the TodoList-mongodb repository


Running:

1. You can start your database by running `mongod`

2. Build the project and run it
    ```
    swift build
    ./build/debug/TodoList
    ```
3. Open the [TodoList Client](http://www.todobackend.com/client/index.html?http://localhost:8090) and enjoy!


Testing:

- Run the test cases with `swift test`
