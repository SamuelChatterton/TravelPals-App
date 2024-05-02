//User Class
import Foundation

struct User: Identifiable, Codable {
    let id: UUID?
    var username: String
    var name: String
    var email: String
    var age: String
    var country: String
    var password: String
    var bio: String
    var interests: String
    var likedposts: String?
}
