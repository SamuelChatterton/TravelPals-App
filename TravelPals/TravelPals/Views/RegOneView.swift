import SwiftUI
import CoreData

struct RegOneView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AddUpdateUserViewModel
    
    @State private var isRegTwoViewPresented = false
    @State private var isShowingRegLogView = false
    @State private var username = ""
    @State private var name = ""
    @State private var email = ""

    @State private var password = ""
    @State private var confpass = ""
    @State private var progress: Double = 0.2
    
    @State private var firstnameError = ""
    @State private var usernameError = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    @State private var confpassError = ""
    
    var body: some View {
        ZStack {
            Image("MS1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                if !isShowingRegLogView {
                    HStack{
                        Spacer()
                        Button(action: { //Go to previous page
                            isShowingRegLogView.toggle()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                }
                ProgressView(value: progress)
                    .padding([.leading, .trailing], 20)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .padding()

                
                
                VStack {
                    VStack{
                        TextField("", text: $viewModel.username, prompt: Text("Username").foregroundColor(.white))
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
                    VStack{
                        TextField("", text: $viewModel.name, prompt: Text("Name").foregroundColor(.white))
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
                    Text(firstnameError)
                        .foregroundColor(.red)
                        .font(.system(size: 15))

                    VStack{
                        TextField("", text: $viewModel.email, prompt: Text("Email").foregroundColor(.white))
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
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.system(size: 15))

                    VStack{
                        SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundColor(.white))
                            .frame(width: UIScreen.main.bounds.width / 1.75, height: 20)
                            .foregroundColor(.white)
                            .textContentType(.none)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width / 1.75, height: 3)
                            .foregroundColor(.clear)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1)), Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                            )

                    }
                    Text(passwordError)
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                        .padding(.bottom, 1)
                    VStack{
                        SecureField("", text: $confpass, prompt: Text("Confirm Password").foregroundColor(.white))
                            .frame(width: UIScreen.main.bounds.width / 1.75, height: 20)
                            .foregroundColor(.white)
                            .textContentType(.none)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width / 1.75, height: 3)
                            .foregroundColor(.clear)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1)), Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                            )
                    }
                    Text(confpassError)
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                        .padding(.bottom, 1)

                    Button(action: {
                        if validateInputs(){ //Check if inputs are valid
                                isRegTwoViewPresented.toggle() //Go to next step
                        }
                    }) {
                        Text("Next")
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
                .frame(width: 300, height: 500)
                .opacity(1)
                .cornerRadius(15)
                
            }
        }
        .fullScreenCover(isPresented: $isShowingRegLogView, content: {
            RegLogView() //Go to previous page
        })
        .fullScreenCover(isPresented: $isRegTwoViewPresented, content: {
            RegTwoView(viewModel: viewModel) //Go to next page
        })
        .transition(.opacity)
    }
    
    
    private func validateInputs() -> Bool {
        //Reset error messages
        firstnameError = ""
        usernameError = ""
        emailError = ""
        passwordError = ""
        confpassError = ""

        var isValid = true

        //Validate firstname
        if viewModel.name.isEmpty {
            firstnameError = "First name is required."
            isValid = false
        }
        
        //Validate username
        if viewModel.username.isEmpty {
            usernameError = "Username is required."
            isValid = false
        }
        
        if viewModel.username.count < 5 {
            usernameError = "Username must be more than 5 characters."
            isValid = false
        }
        
        //Validate email
        if viewModel.email.isEmpty {
            emailError = "Email is required."
            isValid = false
        }

        //Validate password
        if viewModel.password.count < 10 {
            passwordError = "Password must be at least 10 characters."
            isValid = false
        }
        
        if viewModel.password.rangeOfCharacter(from: .decimalDigits) == nil {
            passwordError = "Password must contain at least one number."
            isValid = false
        }
        
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()-_+=[]{}|;:,.<>?")
        if viewModel.password.rangeOfCharacter(from: specialCharacterSet) == nil {
            passwordError = "Password must contain at least one special character."
            isValid = false
        }

        //Validate confirm password
        if confpass.isEmpty || confpass != viewModel.password {
            confpassError = "Passwords do not match."
            isValid = false
        }

        return isValid
    }
}

struct BorderedTextFieldModifier: ViewModifier {
    let borderColor: Color
    let borderWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .background(Color(.white))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }
}


struct RegOneView_Previews: PreviewProvider {
    static var previews: some View {
        RegOneView(viewModel: AddUpdateUserViewModel())
    }
}
