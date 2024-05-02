import Fluent
import Vapor

func routes(_ app: Application) throws {
        app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    //routes above used for testing api

    try app.register(collection: UserController())
    try app.register(collection: PostController())
}
