import SwiftUI
import CoreData

struct Login: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isShowingRegLogView = false
    @State private var isShowingHomeView = false
    @State private var isPopoverPresented = false
    @State private var isPopoverRPPresented = false
    @State private var isPopoverRUPresented = false
    
    @State private var usernameError = ""
    @State private var passwordError = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @StateObject var viewModel = UserViewModel()

    var body: some View {
        ZStack {
            Image("MS1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                    if !isShowingRegLogView {
                        HStack{
                            Button(action: { //Button to go to previous view (reglog view)
                                isShowingRegLogView.toggle()
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .padding(.leading, 40)
                            }
                            Spacer()
                        }
                    }
                    Text("Login")
                        .font(.title)
                        .foregroundColor(.white)
                        .font(.custom("AvenirNext-Medium", size: 33))
                        .padding(.bottom, 20)
                
                
                VStack {
                    TextField("", text: $username, prompt: Text("Username").foregroundColor(.white))
                        .frame(width: UIScreen.main.bounds.width / 1.75, height: 20)
                        .foregroundColor(.white)

                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width / 1.75, height: 3)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1)), Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                        )
                        .padding(.bottom, 5)
                }
                Text(usernameError)
                    .foregroundColor(.red)
                    .font(.system(size: 15))

                VStack {
                    SecureField("", text: $password, prompt: Text("Password").foregroundColor(.white))
                        .frame(width: UIScreen.main.bounds.width / 1.75, height: 20)
                        .foregroundColor(.white)

                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width / 1.75, height: 3)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1)), Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                        )
                        .padding(.bottom, 5)
                }
                Text(passwordError)
                    .foregroundColor(.red)
                    .font(.system(size: 15))
                
                Button(action: { //Button to attempt login
                    sharedViewModel.username = username
                    Task {
                        do {
                            try await viewModel.fetchUsers()
                            //Validate Login details
                            if viewModel.users.contains(where: { $0.username == username && $0.password == password }) {
                                isShowingHomeView = true
                            } else {
                                passwordError = "Invalid login details."
                            }
                        } catch {
                            print("Error during login: \(error)")
                        }
                    }
                }) {
                    Text("Start Exploring")
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
                Spacer()

                .fullScreenCover(isPresented: $isShowingHomeView, content: {
                    HomeView() //Handles succesfull login
                })
            }
        }
        .background(Color.clear)
        .fullScreenCover(isPresented: $isShowingRegLogView, content: {
            RegLogView() //Hangles going back to previous view
        })
    }
    
    private func validateInputs() -> Bool {
        //Reset error messages
        usernameError = ""
        passwordError = ""

        var isValid = true

        //Validate username
        if sharedViewModel.username.isEmpty {
            usernameError = "Please enter your username."
            isValid = false
        }
        
        //Validate password
        if password.isEmpty {
            passwordError = "Please enter your password."
            isValid = false
        }
        return isValid
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}



