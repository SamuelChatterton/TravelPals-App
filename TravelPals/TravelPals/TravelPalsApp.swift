import SwiftUI

@main
struct TravelpalsApp: App {
    @State private var isShowingOpenView = true
    @StateObject var sharedViewModel = SharedViewModel()
    
    init() {
            //Set tob bar to green
            UITabBar.appearance().barTintColor = UIColor(red: 0.0, green: 0.3, blue: 0.0, alpha: 1.0) 
        }
    
    var body: some Scene {
        WindowGroup {
            if isShowingOpenView {
                //Loading Page
                OpenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowingOpenView = false
                            }
                        }
                    }
            } else {
                RegLogView()
                    .environmentObject(sharedViewModel)
            }
        }
    }
}
