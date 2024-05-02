//Loading Screen
import SwiftUI

struct OpenView: View {
    @State private var isLoading = true
    //Loading screen background
    var body: some View {
        ZStack {
            Image("MS1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            Image("A")
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 220)

            if isLoading {
                RotatingLoadingIndicator()
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 220)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            }
        }
    }
}

//Loading Circle built into logo
struct RotatingLoadingIndicator: View {
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1)), Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                .mask(
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color.white, lineWidth: 8)
                        .rotationEffect(Angle(degrees: rotationAngle))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                                self.rotationAngle = 360
                            }
                        }
                )
        }
        .clipShape(Circle())
        .frame(width: 200, height: 200)
    }
}

struct OpenView_Previews: PreviewProvider {
    static var previews: some View {
        OpenView()
    }
}
