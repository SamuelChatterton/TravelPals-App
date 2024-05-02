//Creating User Class
import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "age")
    var age: String
    
    @Field(key: "country")
    var country: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "bio")
    var bio: String
    
    @Field(key: "interests")
    var interests: String
    
    @Field(key: "likedposts")
    var likedposts: String?
    
    init() {}
    
    init(id: UUID? = nil, name: String, username: String, email: String, age: String, country: String, password: String, bio: String, interests: String, likedposts: String){
        self.id = id
        self.username = username
        self.name = name
        self.email = email
        self.age = age
        self.country = country
        self.password = password
        self.bio = bio
        self.interests = interests
        self.likedposts = likedposts
    }
}

