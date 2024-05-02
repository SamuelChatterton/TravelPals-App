import SwiftUI
import CoreData

struct RegFiveView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AddUpdateUserViewModel
    
    @State private var isRegFourViewPresented = false
    @State private var isRegSevenViewPresented = false
    @State private var progress: Double = 1
    @State private var bio: String = ""
    @State private var bioError = ""

    var body: some View {
        ZStack {
            Image("MS1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                if !isRegFourViewPresented {
                    HStack{
                        Spacer()
                        Button(action: { //Go to previous page
                            isRegFourViewPresented.toggle()
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
                
                

                Text("A little bit about you!")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)

                TextEditor(text: $viewModel.bio)
                    .modifier(BorderedTextFieldModifier(borderColor: .black, borderWidth: 1))
                    .frame(width: 380, height: 200)
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .cornerRadius(10)
                    .padding()
                
                Text("\(viewModel.bio.count) / 50")
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .padding(.bottom, 1)
                    .bold()
                
                Text(bioError)
                    .foregroundColor(.red)
                    .font(.system(size: 15))
                    .padding(.bottom, 1)
                
                Button(action: {
                    if validateBio() {
                        isRegSevenViewPresented.toggle()
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
        }
        .fullScreenCover(isPresented: $isRegFourViewPresented, content: {
            RegFourView(viewModel: viewModel)
        })
        .fullScreenCover(isPresented: $isRegSevenViewPresented, content: {
            RegSevenView(viewModel: viewModel)
        })
    }
    
    private func validateBio() -> Bool {
        //Reset error messages
        bioError = ""

        var isValid = true

        //Validate bio
        if viewModel.bio.isEmpty {
            bioError = "Please enter a bio"
            isValid = false
        }

        if viewModel.bio.count < 50 {
            bioError = "Bio must be at least 50 characters"
            isValid = false
        }

        return isValid
    }
}

struct RegFiveView_Previews: PreviewProvider {
    static var previews: some View {
        RegFiveView(viewModel: AddUpdateUserViewModel())
    }
}
