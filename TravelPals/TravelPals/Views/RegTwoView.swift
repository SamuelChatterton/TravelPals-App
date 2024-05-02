import SwiftUI
import CoreData

struct RegTwoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AddUpdateUserViewModel
    
    @State private var isRegOneViewPresented = false
    @State private var isRegThreeViewPresented = false
    @State private var age = ""
    @State private var progress: Double = 0.4
    
    @State private var ageError = ""
    
    var body: some View {
        ZStack {
            Image("MS1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                if !isRegOneViewPresented {
                    HStack{
                        Spacer()
                        Button(action: { //Go to previous page
                            isRegOneViewPresented.toggle()
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
                    TextField("", text: $viewModel.age, prompt: Text("Age").foregroundColor(.white))
                        .frame(width: UIScreen.main.bounds.width / 1.75, height: 20)
                        .foregroundColor(.white)
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width / 1.75, height: 3)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1)), Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                        )
                        .padding(.bottom, 5)
                    
                    Text(ageError)
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                        .padding(.bottom, 1)

                    Button(action: {
                        if validateAge() { //Age check
                            isRegThreeViewPresented.toggle() //Go to next step
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
        .fullScreenCover(isPresented: $isRegOneViewPresented, content: {
            RegOneView(viewModel: viewModel) //Go to previous page
        })
        .fullScreenCover(isPresented: $isRegThreeViewPresented, content: {
            RegThreeView(viewModel: viewModel) //Go to next page
        })
        .transition(.opacity)
    }
    
    private func validateAge() -> Bool {
        //Reset error messages
        ageError = ""

        var isValid = true

        //Validate age
        if viewModel.age.isEmpty {
            ageError = "Age is required."
            isValid = false
        }

        if let ageInt = Int(viewModel.age), ageInt < 18 {
            ageError = "Must be 18 or older."
            isValid = false
        }

        return isValid
    }
}


struct RegTwoView_Previews: PreviewProvider {
    static var previews: some View {
        RegTwoView(viewModel: AddUpdateUserViewModel())
    }
}
