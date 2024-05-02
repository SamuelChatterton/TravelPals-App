import SwiftUI

struct RegSevenView: View {
    @ObservedObject var viewModel: AddUpdateUserViewModel
    
    @State private var isRegFiveViewPresented = false
    @State private var isMainViewPresented = false
    @State private var progress: Double = 1
    var body: some View {
        ZStack {
            Image("MS1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                if !isRegFiveViewPresented {
                    HStack{
                        Spacer()
                        Button(action: { //Go to previous page
                            isRegFiveViewPresented.toggle()
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
                
                Button(action: {
                    viewModel.addUpdateAction { //Add user to database and go to reglogview
                        isMainViewPresented.toggle()
                    }
                }) {
                    Text("Finish")
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
        }
        .fullScreenCover(isPresented: $isRegFiveViewPresented, content: {
            RegFiveView(viewModel: viewModel) //Go to previous page
        })
        .fullScreenCover(isPresented: $isMainViewPresented, content: {
            Login() //Go to login page after succesfull registration
        })
    }
}

struct RegSevenView_Previews: PreviewProvider {
    static var previews: some View {
        RegSevenView(viewModel: AddUpdateUserViewModel())
    }
}
