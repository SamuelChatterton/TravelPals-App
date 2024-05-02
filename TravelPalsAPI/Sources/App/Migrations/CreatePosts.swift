//Create Post Schema
import Fluent

struct CreatePosts: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("posts")
            .id()
            .field("user", .string, .required)
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("privacy", .string, .required)
            .field("startDate", .date, .required)
            .field("endDate", .date, .required)
            .field("locations", .string, .required)
            .field("whatsapp", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("posts").delete()
    }
    
    
}
