import SwiftUI
import CoreData

struct MainView: View {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AddUpdateUserViewModel
    @StateObject var postViewModel = PostViewModel()
    @State private var isPostViewPresented = false
    @State private var isSearchViewPresented = false
    @State private var selectedPost: Post? = nil
    @State private var selectedTab: Tabs = .general
    @State private var filteredPosts: [Post] = []
    @State private var budgetPostsFiltered: [Post] = []
    @State private var likedPosts: [String] = []
    @State private var selectedTabIndex: Int = 0

    //All trip tab types
    enum Tabs: String, CaseIterable {
        case general = "General"
        case recommended = "Recommended"
        case budget = "Budget Travel"
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    HStack {
                        Text("Hello \(sharedViewModel.username)!") //Welcome message to user
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                            .padding(5)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, -100)
                    
                    HStack {
                        //Button to liked trips view
                        NavigationLink(destination: LikedPosts(viewModel: AddUpdateUserViewModel())) {
                            HStack{
                                Text("Liked Trips")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        //Button to search view
                        NavigationLink(destination: SearchView()) {
                            HStack{
                                Text("Search Trips")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        //Button to notif view
                        NavigationLink(destination: NotifView()) {
                            HStack{
                                Text("Notifications")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                Image(systemName: "bell")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                            }
                        }
                    }
                    
                    CustomSegmentedPicker(selectedTab: $selectedTabIndex)
                        .padding()
                    TabView(selection: $selectedTabIndex) {
                        //General Tab
                        ZStack{
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9012677073, green: 0.9697102904, blue: 0.9704253078, alpha: 1)), Color(#colorLiteral(red: 0.8126738667, green: 0.9230485559, blue: 0.9503759742, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                                .edgesIgnoringSafeArea(.all)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 20) {
                                    ForEach(postViewModel.posts) { post in
                                        Button { //Buttons for posts in general tab
                                            isPostViewPresented.toggle()
                                            sharedViewModel.Tuser = post.user
                                            sharedViewModel.tripname = post.title
                                            sharedViewModel.description = post.description
                                            sharedViewModel.privacy = post.privacy
                                            sharedViewModel.startDate = post.startDate
                                            sharedViewModel.endDate = post.endDate
                                            sharedViewModel.locations = post.locations
                                            sharedViewModel.whatsapp = post.whatsapp
                                            sharedViewModel.postid = post.id?.uuidString ?? ""

                                        } label: {
                                            VStack{
                                                ZStack {
                                                    getImage(for: post)
                                                        .resizable()
                                                        .frame(width: UIScreen.main.bounds.width / 1.2, height: 220)
                                                        .clipShape(RoundedTopCorners(cornerRadius: 10))
                                                }
                                                
                                                VStack {
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
                                                            .foregroundColor(.black)
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
                                    }
                                }
                            }
                        }
                        .clipShape(RoundedTopCorners(cornerRadius: 30))
                        .background(Color(red: 0.0, green: 0.3, blue: 0.0))
                        .frame(width: UIScreen.main.bounds.width)
                        .tag(0)
                        
                        //Recommended Tab
                        ZStack{
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9012677073, green: 0.9697102904, blue: 0.9704253078, alpha: 1)), Color(#colorLiteral(red: 0.8126738667, green: 0.9230485559, blue: 0.9503759742, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                                .edgesIgnoringSafeArea(.all)
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    if !filteredPosts.isEmpty {
                                        ScrollView(.vertical, showsIndicators: false) {
                                            VStack(spacing: 20) {
                                                ForEach(filteredPosts) { post in
                                                    Button { //Buttons for posts in recommended tab
                                                        isPostViewPresented.toggle()
                                                        sharedViewModel.Tuser = post.user
                                                        sharedViewModel.tripname = post.title
                                                        sharedViewModel.description = post.description
                                                        sharedViewModel.privacy = post.privacy
                                                        sharedViewModel.startDate = post.startDate
                                                        sharedViewModel.endDate = post.endDate
                                                        sharedViewModel.locations = post.locations
                                                        sharedViewModel.whatsapp = post.whatsapp
                                                        sharedViewModel.postid = post.id?.uuidString ?? ""
                                                    } label: {
                                                        VStack{
                                                            ZStack {
                                                                getImage(for: post)
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
                                }
                            }
                        }
                        .clipShape(RoundedTopCorners(cornerRadius: 30))
                        .background(Color(red: 0.0, green: 0.3, blue: 0.0))
                        .tag(1)
                        ZStack{
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9012677073, green: 0.9697102904, blue: 0.9704253078, alpha: 1)), Color(#colorLiteral(red: 0.8126738667, green: 0.9230485559, blue: 0.9503759742, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                                .edgesIgnoringSafeArea(.all)
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    if !budgetPostsFiltered.isEmpty {
                                        ScrollView(.vertical, showsIndicators: false) {
                                            VStack(spacing: 20) {
                                                ForEach(budgetPostsFiltered) { post in
                                                    Button { //Buttons for posts in budget tab
                                                        isPostViewPresented.toggle()
                                                        sharedViewModel.Tuser = post.user
                                                        sharedViewModel.tripname = post.title
                                                        sharedViewModel.description = post.description
                                                        sharedViewModel.privacy = post.privacy
                                                        sharedViewModel.startDate = post.startDate
                                                        sharedViewModel.endDate = post.endDate
                                                        sharedViewModel.locations = post.locations
                                                        sharedViewModel.whatsapp = post.whatsapp
                                                        sharedViewModel.postid = post.id?.uuidString ?? ""
                                                    } label: {
                                                        VStack{
                                                            ZStack {
                                                                getImage(for: post)
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
                                }
                            }
                        }
                        .clipShape(RoundedTopCorners(cornerRadius: 30))
                        .background(Color(red: 0.0, green: 0.3, blue: 0.0))
                        .tag(2)
                    }
                }
            }
            .accentColor(.black)
            //Fetch all posts when main view appears
            .onAppear {
                Task {
                    do {
                        try await postViewModel.fetchPosts()
                        let filteredPosts = try await filterPosts(posts: postViewModel.posts)
                        let budgetPostsFiltered = try await budgetPostsFilter(posts: postViewModel.posts)
                        DispatchQueue.main.async {
                            self.filteredPosts = filteredPosts
                            self.budgetPostsFiltered = budgetPostsFiltered
                        }
                    } catch {
                        print("Error fetching posts: \(error)")
                    }
                }
            }
            .background(Color(red: 0.0, green: 0.3, blue: 0.0))
            .fullScreenCover(isPresented: $isSearchViewPresented, content: {
                SearchView()
            })
        }

        //Fetch user interests of each post
        private func fetchPostUserDetails(for post: Post) async -> [String]? {
            do {
                let usernameToFetch = post.user
                if let user = try await viewModel.fetchUserDetails(username: usernameToFetch) {
                    let postInterests = processUserInterests(userInterests: user.interests)
                    return postInterests
                }
            } catch {
                print("Error fetching additional user details for \(post.user): \(error)")
            }
            return nil
        }
        
        private func processUserInterests(userInterests: String) -> [String] {
            let interestsArray = userInterests.components(separatedBy: ",")
            return interestsArray
        }
        
        //Filter posts with a similarity of 50% >= for the logged in user
        private func filterPosts(posts: [Post]) async throws -> [Post] {
            var filteredPosts: [Post] = []
            for post in posts {
                let currentPostUser = post.user
                if let currentUser = try await viewModel.fetchUserDetails(username: sharedViewModel.username),
                   let postUser = try await viewModel.fetchUserDetails(username: currentPostUser) {
                    
                    let currentUserInterests = processUserInterests(userInterests: currentUser.interests)
                    let postUserInterests = processUserInterests(userInterests: postUser.interests)
                    
                    let similarity = calculateJaccardSimilarity(interests1: currentUserInterests, interests2: postUserInterests)
                    
                    print("Jaccard Similarity between \(sharedViewModel.username) and \(currentPostUser): \(similarity * 100)%")
                    
                    if similarity >= 0.5 {
                        filteredPosts.append(post)
                    }
                }
            }
            return filteredPosts
        }
    
        //Jaccard similarity function
        private func calculateJaccardSimilarity(interests1: [String], interests2: [String]) -> Double {
            let set1 = Set(interests1)
            let set2 = Set(interests2)
            
            let intersection = set1.intersection(set2)
            let union = set1.union(set2)
            
            let similarity = Double(intersection.count) / Double(union.count)
            return similarity
        }
    
        //Fetch logged in user interests
        private func fetchUserInterests(username: String) {
            Task {
                do {
                    if let user = try await viewModel.fetchUserDetails(username: username) {
                        sharedViewModel.selectedInterests = user.interests
                    }
                } catch {
                    print("Error fetching additional user details: \(error)")
                }
            }
        }
    
    //Creating list of posts with keyword budget
    private func budgetPostsFilter(posts: [Post]) async throws -> [Post] {
        var budgetPosts: [Post] = []
        let keyword = "budget"
        
        for post in posts {
                if post.title.lowercased().contains(keyword) || post.description.lowercased().contains(keyword) {
                    budgetPosts.append(post)
                }
            }
        
        return budgetPosts
    }
    //Choose Image based of text in post
    private func getImage(for post: Post) -> Image {
            if post.title.contains("ski") || post.description.contains("ski") {
                return Image("ski")
            } else if post.title.contains("asia") || post.description.contains("Asia") {
                return Image("asia")
            } else if post.title.contains("surf") || post.description.contains("surf") {
                return Image("surf")
            } else if post.title.contains("hiking") || post.description.contains("hiking") {
                return Image("hiking")
            } else if post.title.contains("Africa") || post.description.contains("Africa") {
                return Image("africa")
            } else if post.title.contains("interrail") || post.description.contains("interrail") {
                return Image("interrail")
            } else if post.title.contains("Interrail") || post.description.contains("Interrail") {
                return Image("interrail")
            } else if post.title.contains("museum") || post.description.contains("museum") {
                return Image("mus")
            } else {
                return Image("beach")
            }
        }

}
//Tab customisation for different tabs on main view
struct CustomSegmentedPicker: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false){
            HStack {
                Text("General")
                    .foregroundColor(selectedTab == 0 ? .white : .white)
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = 0
                        }
                    }
                
                Text("Recommended")
                    .foregroundColor(selectedTab == 1 ? .white : .white)
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = 1
                        }
                    }
                
                Text("Budget Travel")
                    .foregroundColor(selectedTab == 2 ? .white : .white)
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = 2
                        }
                    }
                
            }
            .background(Color(red: 0.0, green: 0.3, blue: 0.0))
            ZStack{
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color.white)
                    .frame(width: selectedTab == 0 ? getWidthForTab(index: 0) : (selectedTab == 1 ? getWidthForTab(index: 1) : getWidthForTab(index: 2)))
                    .offset(x: selectedTab == 0 ? 0 : UIScreen.main.bounds.width / 4)
                    .offset(x: selectedTab == 0 ? -150 : (selectedTab == 1 ? -128 : 20))
            }
        }
        }
        .padding(.horizontal)
    }
    //Get width of rectangle for each tab word
    func getWidthForTab(index: Int) -> CGFloat {
        let tabTitles = ["General", "Recommended","Budget Travel"]
        let selectedTabTitle = tabTitles[index]
        let textWidth = selectedTabTitle.widthOfString(usingFont: .systemFont(ofSize: 17, weight: .semibold))
        return textWidth + 16
    }
}

//Round top corners for images for posts
struct RoundedTopCorners: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius), control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

//Get width of string to size rectangle for custom tab
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

struct MainViewTest_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: AddUpdateUserViewModel())
    }
}
