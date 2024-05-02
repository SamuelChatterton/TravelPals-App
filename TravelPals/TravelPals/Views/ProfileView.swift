import SwiftUI
import CoreData

struct ProfileView: View {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AddUpdateUserViewModel
    @State private var selectedTab: Tabs = .yourProfile

    enum Tabs: String, CaseIterable {
        case yourProfile = "Your Profile"
        case joinedTrips = "Joined Trips"
        case yourTrips = "Your Trips"
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedTab, label: Text("")) {
                    ForEach(Tabs.allCases, id: \.self) { tab in
                        Text(tab.rawValue)
                    }
                }
                .shadow(radius: 10)
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Spacer()

                //Tabs for profile view
                switch selectedTab {
                case .yourProfile:
                    YourProfileView(viewModel: AddUpdateUserViewModel())
                case .joinedTrips:
                    JoinedTripsView()
                case .yourTrips:
                    YourTripsView()
                }
            }
            .navigationTitle("Profile")
        }
    }
}
//Logged in user's profile
struct YourProfileView: View {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AddUpdateUserViewModel
    @State var modal: ModelType? = nil
    @State private var isColorSelectionViewPresented = false
    @State private var selectedColor: Color?
    @State private var islogin = false

    @State private var selectedImage: Image?

    var body: some View {
        ScrollView {
            VStack {
                HStack{
                    Text(sharedViewModel.firstname)
                        .font(.largeTitle)
                        .offset(x: +20)
                    Spacer()
                }
                HStack{
                    Text(sharedViewModel.username)
                        .font(.headline)
                        .offset(x: +20)
                    Spacer()
                }
                if let selectedImage = sharedViewModel.selectedImage {
                    selectedImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                        .clipped()
                        .clipShape(Rectangle())
                        .padding(5)
                } else {
                    getImageP(for: sharedViewModel.username)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                        .clipped()
                        .clipShape(Rectangle())
                        .padding(5)
                }
                VStack{
                    HStack{
                        Text(sharedViewModel.age)
                            .font(.system(size: 15))
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                    HStack{
                        Text(sharedViewModel.country)
                            .font(.system(size: 15))
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                    Rectangle()
                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.0))
                        .frame(height: 3)
                        .padding(.horizontal, 16)
                    Text("")
                    HStack{
                        Spacer()
                        Text(sharedViewModel.bio)
                            .font(.system(size: 15))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(nil)
                                    .padding(.horizontal, 5)
                        Spacer()
                            }
                    Rectangle()
                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.0))
                        .frame(height: 3)
                        .padding(.horizontal, 16)
                    Spacer()
                    HStack{
                        Text("My Interests")
                            .font(.largeTitle)
                            .offset(x: +20)
                        Spacer()
                    }
                    VStack {
                        if !sharedViewModel.selectedInterests.isEmpty { //Fetch user's interests
                            let interestsArray = sharedViewModel.selectedInterests.components(separatedBy: ",")
                            ForEach(interestsArray, id: \.self) { selectedInterest in
                                Text("- \(selectedInterest) -")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    }
                }
            .foregroundColor(.black)
            .background(Color.white)
                Spacer()
                    
                Rectangle()
                    .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.0))
                    .frame(height: 3)
                    .padding(.horizontal, 16)
            
            Button(action: { //Logout button
                islogin.toggle()
             }) {
                 Text("Logout")
                     .bold()
                     .foregroundColor(.black)
                     .padding()
             }
                .padding()
                .fullScreenCover(isPresented: $islogin) {
                    Login()
                }
        }
        //Fetch user details when view appears
        .onAppear{
            Task {
                do {
                    if let user = try await viewModel.fetchUserDetails(username: sharedViewModel.username) {
                        sharedViewModel.firstname = user.name
                        sharedViewModel.username = user.username
                        sharedViewModel.age = user.age
                        sharedViewModel.bio = user.bio
                        sharedViewModel.country = user.country
                        sharedViewModel.selectedInterests = user.interests
                    }
                } catch {
                    print("Error fetching additional user details: \(error)")
                }
            }
        }
    }
    
    //Fetch user's details
    private func fetchAdditionalUserDetails(username: String) {
        Task {
            do {
                if let user = try await viewModel.fetchUserDetails(username: username) {
                    sharedViewModel.firstname = user.name
                    sharedViewModel.username = user.username
                    sharedViewModel.age = user.age
                    sharedViewModel.bio = user.bio
                    sharedViewModel.country = user.country
                    sharedViewModel.selectedInterests = user.interests
                }
            } catch {
                print("Error fetching additional user details: \(error)")
            }
        }
    }
    
    //Fetch users interests
    func getUserInterestsList() -> [String] {
        guard !sharedViewModel.selectedInterests.isEmpty else {
            return []
        }

        let interestArray = sharedViewModel.selectedInterests.components(separatedBy: ",")
        print("User Interests: \(interestArray)")
        return interestArray
    }
    //Current state a default image is chosen for profiles (In future users can choose their own profile images)
    private func getImageP(for userr: String) -> Image {
        if sharedViewModel.username == "SamuelChat" {
            return Image("Samuel")
        } else if sharedViewModel.username == "Emiryyy" {
            return Image("Emiryyy")
        } else if sharedViewModel.username == "Sammyyy" {
            return Image("me")
        } else if sharedViewModel.username == "EmmaBee" {
            return Image("EmmaBee")
        } else if sharedViewModel.username == "MichaelPort" {
            return Image("mic")
        } else if sharedViewModel.username == "BenPrance" {
            return Image("ben")
        } else {
            return Image("me")
        }
    }
}

struct JoinedTripsView: View {
    var body: some View {
        Text("") //To be implemented in the future of TravelPals
    }
}
//Trips the logged in user has posted
struct YourTripsView: View {
    @StateObject var postViewModel = PostViewModel()
    @EnvironmentObject var sharedViewModel: SharedViewModel

    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(postViewModel.posts) { post in
                    if post.user == sharedViewModel.username {
                        VStack(alignment: .leading) {
                            ZStack {
                                getImage(for: post.title, description: post.description)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width / 2.25, height: 120)
                                    .clipShape(RoundedTopCorners(cornerRadius: 10))
                            }
                            Spacer()

                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(post.title)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .offset(x: 10)
                                }
                                Spacer()
                                HStack {
                                Text(post.locations)
                                    .font(.system(size: 14))
                                    .offset(x: 10)

                                    Spacer()
                                    if post.privacy == "Private" {
                                        Image(systemName: "lock")
                                            .offset(x: -5)
                                            .font(.system(size: 14))
                                    } else {
                                        Image(systemName: "lock.open")
                                            .offset(x: -5)
                                            .font(.system(size: 14))
                                    }
                                }
                                .padding()
                            }

                        }
                        .frame(width: UIScreen.main.bounds.width / 2.25, height: 220)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }
                }
            }
        }
        //Fetch posts when view appears
        .onAppear {
            Task {
                do {
                    try await postViewModel.fetchPosts()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    //Choose Image based of text in post
    private func getImage(for tripName: String, description: String) -> Image {
            if tripName.contains("ski") || description.contains("ski") {
                return Image("ski")
            } else if tripName.contains("asia") || description.contains("Asia") {
                return Image("asia")
            } else if tripName.contains("surf") || description.contains("surf") {
                return Image("surf")
            } else if tripName.contains("hiking") || description.contains("hiking") {
                return Image("hiking")
            } else if tripName.contains("Africa") || description.contains("Africa") {
                return Image("africa")
            } else if tripName.contains("interrail") || description.contains("interrail") {
                return Image("interrail")
            } else if tripName.contains("Interrail") || description.contains("Interrail") {
                return Image("interrail")
            } else {
                return Image("beach")
            }
        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: AddUpdateUserViewModel())
    }
}
