import SwiftUI

struct RegLogView: View {
    @State private var isLoginViewPresented = false
    @State private var isRegisterViewPresented = false
    @State private var isPopoverPresented = false
    
    var body: some View {
        ZStack {
            Image("MS1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                Spacer()
                Text("Welcome to TravelPals")
                    .font(.custom("AvenirNext-Medium", size: 33))
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1)), Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                            .mask(Text("Welcome to TravelPals").font(.custom("AvenirNext-Medium", size: 33)))
                    )
                    .padding(.bottom, 5)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)




                Button(action: { //Go to login page
                    isLoginViewPresented.toggle()
                }) {
                    VStack {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 65)
                                    .stroke(
                                        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1)), Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1))]), startPoint: .leading, endPoint: .trailing),
                                        lineWidth: 5
                                    )
                            )
                            .cornerRadius(65)
                            .shadow(color: Color.white.opacity(0.8), radius: 5, x: 0, y: 0)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                }
                .padding()

                Button(action: {//Go to register page
                    isRegisterViewPresented.toggle()
                }) {
                    VStack {
                        Text("Register")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 65)
                                    .stroke(
                                        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1)), Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1))]), startPoint: .leading, endPoint: .trailing),
                                        lineWidth: 5
                                    )
                            )
                            .cornerRadius(65)
                            .shadow(color: Color.white.opacity(0.8), radius: 5, x: 0, y: 0)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                }
                .padding()
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isLoginViewPresented, content: {
            Login() //Handles going to login page
        })
        .fullScreenCover(isPresented: $isRegisterViewPresented, content: {
            RegOneView(viewModel: AddUpdateUserViewModel()) //Handles going to register page
        })
    }
}

struct RegLogView_Previews: PreviewProvider {
    static var previews: some View {
        RegLogView()
    }
}

