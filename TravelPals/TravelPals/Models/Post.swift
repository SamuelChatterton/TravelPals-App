//Post Class
import Foundation

struct Post: Identifiable, Codable {
    let id: UUID?
    var user: String
    var title: String
    var description: String
    var privacy: String
    var startDate: String
    var endDate: String
    var locations: String
    var whatsapp: String
}
