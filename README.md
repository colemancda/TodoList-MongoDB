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


Running Locally:

1. You can start your database by running `mongod`

2. Build the project and run it
    ```
    swift build
    ./build/debug/TodoList
    ```
3. Open the [TodoList Client](http://www.todobackend.com/client/index.html?http://localhost:8090) and enjoy!

Deploying To Bluemix:

1. Get an account for [Bluemix](https://new-console.ng.bluemix.net/?direct=classic)

2. Download and install the [Cloud Foundry tools](https://new-console.ng.bluemix.net/docs/starters/install_cli.html):

    ```
    cf login
    bluemix api https://api.ng.bluemix.net
    bluemix login -u username -o org_name -s space_name
    ```

    Be sure to change the directory to the todolist-mongodb directory where the manifest.yml file is located.

3. Run `cf push`

    #### Note: The uploading droplet stage should take a long time, roughly 4-6 minutes. If it worked correctly, it should say:

    ```
    2 of 2 instances running

    App started
    ```

4. Create the MongoDB backend and attach it to your instance.

```
cf create-service cloudantNoSQLDB Shared database_name
cf bind-service todolist-mongodb database_name
cf restage
```

Testing:

- Run the test cases with `swift test`

## License

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](LICENSE).
