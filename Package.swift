import PackageDescription

let package = Package(
    name: "TodoList",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/todolist-web.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/PlanTeam/MongoKitten.git", majorVersion: 1, minor: 4),
        .Package(url: "https://github.com/jsphyin/Swift-cfenv.git", majorVersion: 1, minor: 5),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 0, minor: 14),
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 25)
    ]
)
