import SwiftUI

struct HomeView: View {

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            MainView(viewModel: AddUpdateUserViewModel()) //Main View
                .tabItem {
                    Image(systemName: "house")
                        .foregroundColor(.white)
                    Text("Home")
                        .foregroundColor(.white)
                }
                .tag(0)
            
            PostDB(viewModel: AddUpdateUserViewModel(), postViewModel: AddUpdatePostViewModel()) //Create Post
                .tabItem {
                    Image(systemName: "plus.app")
                        .foregroundColor(.white)
                    Text("Create Trip")
                        .foregroundColor(.white)
                }
                .tag(1)
            
            ProfileView(viewModel: AddUpdateUserViewModel()) //Profile View
            .tabItem {
                Image(systemName: "person")
                    .foregroundColor(.white)
                Text("Profile")
                    .foregroundColor(.white)
            }
            .tag(2)
        }
        .accentColor(Color.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
