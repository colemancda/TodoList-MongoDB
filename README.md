# Todolist CouchDB

Todolist implemented for Cloudant (MongoDB) backend

Quick start:

- Download the [Swift DEVELOPMENT 05-03 snapshot](https://swift.org/download/#snapshots)
- Download MongoDB
  You can use `brew install mongodb` or `apt-get install couchdb`
  - If you are using mongodb for the first time create the directory to which the mongod process will write data
  `mkdir -p /data/db`
  - More information can be found [here](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/)
- Clone the TodoList mongodb repository
- Fetch the test cases by running `git submodule init` then `git submodule update`
- Compile the library with `swift build` on Mac OS or `swift build -Xcc -fblocks` on Linux
- Run the test cases with `swift test`



Running:

You can start your database by running `mongod` and view the database in its local shell with `mongo`
