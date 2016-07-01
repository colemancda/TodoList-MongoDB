import PackageDescription

let package = Package(
    name: "TodoList",
    dependencies: [
        .Package(url: "https://758deef7b3c423479b6826fb845008067a69d556@github.com/IBM-Swift/todolist-web.git", majorVersion: 0, minor: 0),
        .Package(url: "https://github.com/PlanTeam/MongoKitten.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/IBM-Swift/Swift-cfenv.git", majorVersion: 1, minor: 3)
    ]
)
