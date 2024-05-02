//Creating Post Class
import Fluent
import Vapor

final class Post: Model, Content {
    static let schema = "posts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user")
    var user: String
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "privacy")
    var privacy: String
    
    @Field(key: "startDate")
    var startDate: Date
    
    @Field(key: "endDate")
    var endDate: Date
    
    @Field(key: "locations")
    var locations: String
    
    @Field(key: "whatsapp")
    var whatsapp: String
    
    init() {}
    
    init(id: UUID? = nil, user: String, title: String, description: String, privacy: String, startDate: Date, endDate: Date, locations: String, whatsapp: String){
        self.id = id
        self.user = user
        self.title = title
        self.description = description
        self.privacy = privacy
        self.startDate = startDate
        self.endDate = endDate
        self.locations = locations
        self.whatsapp = whatsapp
    }
}

