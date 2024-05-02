//User View Model
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var users = [User]()
    
    //Fetch Users from server
    func fetchUsers() async throws {
        let urlString = Constants.baseURL + Endpoints.users
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let  userResponse : [User] = try await HttpClient.shared.fetch(url:url)
        
        DispatchQueue.main.async{
            self.users = userResponse
        }
    }

    //Delete a user
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            guard let userID = users[i].id else {
                return
            }
            
            guard let url = URL(string: Constants.baseURL + Endpoints.users + "/\(userID)")else{
                return
            }
            
            Task {
                do{
                    try await HttpClient.shared.delete(at: userID, url: url)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        users.remove(atOffsets: offsets)
    }
}
