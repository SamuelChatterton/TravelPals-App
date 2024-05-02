//AddUpdateUserViewModel
import SwiftUI

final class AddUpdateUserViewModel: ObservableObject{
    @Published var username = ""
    @Published var name = ""
    @Published var email = ""
    @Published var age = ""
    @Published var country = ""
    @Published var password = ""
    @Published var bio = ""
    @Published var interests = ""
    @Published var likedposts = ""
    
    var userID: UUID?
    
    var isUpdating: Bool {
        userID != nil
    }
    
    var buttonTitle: String{
        userID != nil ? "Update username" : "Add to database"
    }
    
    init() {}
    
    init(currentUser: User) {
        self.userID = currentUser.id
        self.username = currentUser.username
        self.name = currentUser.name
        self.email = currentUser.email
        self.age = currentUser.age
        self.country = currentUser.country
        self.password = currentUser.password
        self.bio = currentUser.bio
        self.interests = currentUser.interests
        self.likedposts = currentUser.likedposts ?? ""
    }
    
    //Add a user
    func addUser() async throws {
        let urlString = Constants.baseURL + Endpoints.users
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }

        let user = User(id: nil, username: username, name: name, email: email, age: age, country: country, password: password, bio: bio, interests: interests, likedposts: likedposts)
        
        try await HttpClient.shared.sendData(to: url, object: user, httpMethod: HttpMethods.POST.rawValue)
    }
    
    //Fetch a users details
    func fetchUserDetails(username: String) async throws -> User? {
            let urlString = Constants.baseURL + Endpoints.users + "?username=\(username)"

            guard let url = URL(string: urlString) else {
                throw HttpError.badURL
            }

            do {
                let users: [User] = try await HttpClient.shared.fetch(url: url)
                return users.first(where: { $0.username == username })
            } catch {
                print("Error fetching user details: \(error)")
                throw error
            }
        }
    
    //Add or update a user
    func addUpdateAction(completion: @escaping () -> Void) {
        Task {
            do{
                if isUpdating {
                    try await updateUser()
                } else {
                    try await addUser()
                }
            } catch {
                print("Error: \(error)")
            }
            completion()
        }
    }
    
    //Update User details
    func updateUser() async throws {
        let urlString = Constants.baseURL + Endpoints.users
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }

        let userToUpdate = User(id: userID, username: username, name: name, email: email, age: age, country: country, password: password, bio: bio, interests: interests, likedposts: likedposts)
        try await HttpClient.shared.sendData(to: url, object: userToUpdate, httpMethod: HttpMethods.PUT.rawValue)
    }
}
