import SwiftUI

struct NotifView: View {

    var body: some View {
        ZStack{
        VStack {
            Text("Notifications")
                .padding(.leading)
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9012677073, green: 0.9697102904, blue: 0.9704253078, alpha: 1)), Color(#colorLiteral(red: 0.8126738667, green: 0.9230485559, blue: 0.9503759742, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) { //To be added in the future of TravelPals
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
}

