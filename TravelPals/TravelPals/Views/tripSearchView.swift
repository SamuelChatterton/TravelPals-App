import SwiftUI

struct tripSearchView: View {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @StateObject var postViewModel = PostViewModel()
    @State private var isPostViewPresented = false

    var body: some View {
        NavigationView {
            ZStack{
            VStack {
                Text("Search Results")
                    .padding(.leading)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9012677073, green: 0.9697102904, blue: 0.9704253078, alpha: 1)), Color(#colorLiteral(red: 0.8126738667, green: 0.9230485559, blue: 0.9503759742, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(filteredPosts, id: \.id) { post in
                                Button { //Create button for searched trip results
                                    isPostViewPresented.toggle()
                                    sharedViewModel.user = post.user
                                    sharedViewModel.tripname = post.title
                                    sharedViewModel.description = post.description
                                    sharedViewModel.privacy = post.privacy
                                    sharedViewModel.startDate = post.startDate
                                    sharedViewModel.endDate = post.endDate
                                    sharedViewModel.locations = post.locations
                                } label: {
                                    PostItemView(post: post)
                                }
                                .fullScreenCover(isPresented: $isPostViewPresented) {
                                    TripView(viewModel: AddUpdateUserViewModel(), postViewModel: AddUpdatePostViewModel())
                                }
                            }
                        }
                    }
                }
                .clipShape(RoundedTopCorners(cornerRadius: 30))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color(red: 0.0, green: 0.3, blue: 0.0))
        }
        }
        //Fetch posts when view appears
        .onAppear {
            Task {
                do {
                    try await postViewModel.fetchPosts()
                } catch {
                    print("Error fetching posts: \(error)")
                }
            }
        }
    }

    //Filter posts with searched words
    private var filteredPosts: [Post] {
        guard !sharedViewModel.tripSearch.isEmpty else {
            return postViewModel.posts
        }

        let searchKeywords = sharedViewModel.tripSearch.lowercased().components(separatedBy: CharacterSet.whitespacesAndNewlines)

        return postViewModel.posts.filter { post in
            let postContent = "\(post.title) \(post.description)\(post.locations)".lowercased()

            return searchKeywords.contains { keyword in
                postContent.contains(keyword)
            }
        }
        .filter { post in
            
            //Filter by public or private
            if !sharedViewModel.stripSearchPP.isEmpty {
                if post.privacy != sharedViewModel.stripSearchPP {
                    return false
                }
            }
            
            //FIlter with selected countries
            if !sharedViewModel.stripSearchLoc.isEmpty {
                let postLocations = Set(post.locations.components(separatedBy: ", "))
                let selectedLocations = Set(sharedViewModel.stripSearchLoc)
                if !selectedLocations.isSubset(of: postLocations) {
                    return false
                }
            }
            
            return true
        }
    }

    
}
//Create a post label
struct PostItemView: View {
    let post: Post

    var body: some View {
        VStack{
            ZStack {
                getImage(for: post.title, description: post.description)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 1.2, height: 220)
                    .clipShape(RoundedTopCorners(cornerRadius: 10))
            }
            
            VStack {
                HStack {
                    Text(post.title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .offset(x: 10)
                    Spacer()
                }
                
                HStack{
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Text(post.locations)
                        .font(.system(size: 14))
                        .offset(x: 10)
                    Spacer()
                    
                    if (post.privacy == "Private"){
                        Image(systemName: "lock")
                            .offset(x:-5)
                            .font(.system(size: 14))
                    } else{
                        Image(systemName: "lock.open")
                            .offset(x:-5)
                            .font(.system(size: 14))
                    }
                }
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width / 1.2, height: 320)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding()
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
            } else {
                return Image("beach")
            }
        }
}
