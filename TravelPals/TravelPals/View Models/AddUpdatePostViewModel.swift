//AddUpdatePostViewModel
import SwiftUI

final class AddUpdatePostViewModel: ObservableObject{
    @Published var user = ""
    @Published var title = ""
    @Published var description = ""
    @Published var privacy = ""
    @Published var startDate = ""
    @Published var endDate = ""
    @Published var locations = ""
    @Published var formattedStartDate = ""
    @Published var formattedEndDate = ""
    @Published var whatsapp = ""

    
    var postID: UUID?
    
    var isUpdating: Bool {
        postID != nil
    }
    
    var buttonTitle: String{
        postID != nil ? "Update title" : "Add to database"
    }
    
    init() {}
    
    init(currentPost: Post) {
        self.postID = currentPost.id
        self.user = currentPost.user
        self.title = currentPost.title
        self.description = currentPost.description
        self.privacy = currentPost.privacy
        self.startDate = currentPost.startDate
        self.endDate = currentPost.endDate
        self.locations = currentPost.locations
        self.whatsapp = currentPost.whatsapp
    }
    
    //Add a post
    func addPost() async throws {
        let urlString = Constants.baseURL + Endpoints.posts
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let post = Post(id: nil, user: user, title: title, description: description, privacy: privacy, startDate: startDate, endDate: endDate, locations: locations, whatsapp: whatsapp)
        
        try await HttpClient.shared.sendData(to: url, object: post, httpMethod: HttpMethods.POST.rawValue)
    }

    //Fetch post details
    func fetchPostDetails(username: String) async throws -> Post? {
            let urlString = Constants.baseURL + Endpoints.posts + "?title=\(title)"

            guard let url = URL(string: urlString) else {
                throw HttpError.badURL
            }

            do {
                let posts: [Post] = try await HttpClient.shared.fetch(url: url)
                return posts.first(where: { $0.title == title })
            } catch {
                print("Error fetching post details: \(error)")
                throw error
            }
        }
    
    //Add or update a post
    func addUpdateAction(completion: @escaping () -> Void) {
        Task {
            do{
                if isUpdating {
                    try await updatePost()
                } else {
                    try await addPost()
                }
            } catch {
                print("Error: \(error)")
            }
            completion()
        }
    }
    
    //Update a post
    func updatePost() async throws {
        let urlString = Constants.baseURL + Endpoints.posts
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let postToUpdate = Post(id: nil, user: user, title: title, description: description, privacy: privacy, startDate: startDate, endDate: endDate, locations: locations, whatsapp: whatsapp)
        try await HttpClient.shared.sendData(to: url, object: postToUpdate, httpMethod: HttpMethods.PUT.rawValue)
    }
}
