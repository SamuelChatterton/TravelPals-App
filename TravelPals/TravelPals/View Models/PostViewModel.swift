//PostViewModel
import SwiftUI

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    //Fetch posts from server
    func fetchPosts() async throws {
        let urlString = Constants.baseURL + Endpoints.posts
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let  postResponse : [Post] = try await HttpClient.shared.fetch(url:url)
        
        DispatchQueue.main.async{
            self.posts = postResponse
        }
    }

    //Delete a post
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            guard let postID = posts[i].id else {
                return
            }
            
            guard let url = URL(string: Constants.baseURL + Endpoints.posts + "/\(postID)")else{
                return
            }
            
            Task {
                do{
                    try await HttpClient.shared.delete(at: postID, url: url)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        posts.remove(atOffsets: offsets)
    }
}
