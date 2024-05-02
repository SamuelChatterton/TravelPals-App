import SwiftUI

struct LikedPosts: View {
    @ObservedObject var viewModel: AddUpdateUserViewModel
    @StateObject var postViewModel = PostViewModel()
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @State private var isPostViewPresented = false

    var body: some View {
        ZStack{
        VStack {
            Text("Liked Posts")
                .padding(.leading)
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9012677073, green: 0.9697102904, blue: 0.9704253078, alpha: 1)), Color(#colorLiteral(red: 0.8126738667, green: 0.9230485559, blue: 0.9503759742, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(getLikedPosts()) { post in
                            Button { //Create button for each liked post
                                isPostViewPresented.toggle()
                                sharedViewModel.user = post.user
                                sharedViewModel.tripname = post.title
                                sharedViewModel.description = post.description
                                sharedViewModel.privacy = post.privacy
                                sharedViewModel.startDate = post.startDate
                                sharedViewModel.endDate = post.endDate
                                sharedViewModel.locations = post.locations
                            } label: {
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
                                                .foregroundColor(.black)
                                                .font(.system(size: 14))
                                                .offset(x: 10)
                                            Spacer()
                                            
                                            if (post.privacy == "Private"){
                                                Image(systemName: "lock")
                                                    .offset(x:-5)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.black)
                                            } else{
                                                Image(systemName: "lock.open")
                                                    .offset(x:-5)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .fullScreenCover(isPresented: $isPostViewPresented) {
                                    TripView(viewModel: AddUpdateUserViewModel(), postViewModel: AddUpdatePostViewModel())
                                }
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 320)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .padding()
                            }
                            .shadow(color: Color.white.opacity(0.8), radius: 20, x: 0, y: 0)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .clipShape(RoundedTopCorners(cornerRadius: 30))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(red: 0.0, green: 0.3, blue: 0.0))
    }
    //Fetch posts when liked view appears
    .onAppear{
        Task {
            do {
                try await postViewModel.fetchPosts()
            } catch {
                print("Error: \(error)")
            }
        }

    }
    }
    //Check which posts have been liked
    func getLikedPosts() -> [Post] {
        return postViewModel.posts.filter { post in
            if let postId = post.id {
                return sharedViewModel.likedTrips.contains(postId.uuidString)
            }
            return false
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

struct LikedPosts_Previews: PreviewProvider {
    static var previews: some View {
        LikedPosts(viewModel: AddUpdateUserViewModel())
    }
}
