//Create User Schema
import Fluent

struct CreateUsers: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("username", .string, .required)
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("age", .string, .required)
            .field("country", .string, .required)
            .field("password", .string, .required)
            .field("bio", .string, .required)
            .field("interests", .string, .required)
            .field("likedposts", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
    
    
}
