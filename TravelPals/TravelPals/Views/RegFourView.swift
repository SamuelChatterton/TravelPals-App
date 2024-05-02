import SwiftUI
import CoreData

struct RegFourView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AddUpdateUserViewModel
    
    @State private var isRegThreeViewPresented = false
    @State private var isRegFiveViewPresented = false
    @State private var progress: Double = 0.8
    @State private var count: Int = 0
    @State private var interError = ""
    
    //Interest list
    let interestOptions = ["Hiking", "Camping", "Night Life", "Exploring", "Interrailing", "Eating Out", "Fun Activities", "Hidden Gems", "Historic Sites", "Trying Local Food", "Relaxation", "Photography", "Scuba Diving", "Birdwatching", "Yoga", "Rock Climbing", "Surfing", "Wildlife Conservation", "Cooking Classes", "Art Galleries", "Live Music", "Volunteering", "Stargazing", "Local Festivals", "Horseback Riding", "Wine Tasting", "Ghost Tours", "Cultural Festivals", "River Rafting", "Road Trips", "Spa Retreats"]

    
    @State private var interests: [String] = []
    @State private var interestsString: String = ""

    var body: some View {
        ZStack {
            Image("MS1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                if !isRegThreeViewPresented {
                    HStack{
                        Spacer()
                        Button(action: { //Go to previous page
                            isRegThreeViewPresented.toggle()
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
                
                Text("Interests")
                    .font(.title)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1)), Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                            .mask(Text("Interests").font(.title))
                    )
                    .padding(.bottom, 20)
                
                
                VStack {
                ScrollView(showsIndicators: false) {
                        ForEach(interestOptions, id: \.self) { interest in
                            Button(action: {
                                toggleInterestSelection(interest)
                            }) {
                                Text(interest)
                                    .foregroundColor(.white)
                                    .padding(5)
                            }
                        }
                    }
                }
                .frame(width: 300, height: 300)
                .background(Color.black)
                .opacity(0.7)
                .cornerRadius(15)
                
                VStack {
                    ScrollView{
                        ForEach(interests, id: \.self) { selectedInterest in
                            Text(selectedInterest)
                                .foregroundColor(.black)
                                .cornerRadius(15)
                                .padding(1)
                        }
                    }
                }
                .frame(width: 300, height: 250)
                .background(Color.white)
                .opacity(0.7)
                .cornerRadius(15)
                
                Text(interError)
                    .foregroundColor(.red)
                    .font(.system(size: 15))
                    .padding(.bottom, 1)
                
                Button(action: {
                    if validateInterests() { //Interests check
                        viewModel.interests = interestsString
                        isRegFiveViewPresented.toggle() //Go to next step
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
        .fullScreenCover(isPresented: $isRegThreeViewPresented, content: {
            RegThreeView(viewModel: viewModel) //Go to previous page
        })
        .fullScreenCover(isPresented: $isRegFiveViewPresented, content: {
            RegFiveView(viewModel: viewModel) //Go to next page
        })
    }
    
    //Keep count of interests
    func toggleInterestSelection(_ interest: String) {
        if interests.contains(interest) {
            count -= 1
            interests.removeAll { $0 == interest }
        } else {
            count += 1
            interests.append(interest)
        }
        interestsString = interests.joined(separator: ",")
    }
    
    private func validateInterests() -> Bool {
        //Reset error messages
        interError = ""

        var isValid = true

        //Validate interests
        if count == 0 {
            interError = "Please select 5 interests or more"
            isValid = false
        }

        if count < 5 {
            interError = "Please select at least 5 interests"
            isValid = false
        }

        return isValid
    }
}

struct RegFourView_Previews: PreviewProvider {
    static var previews: some View {
        RegFourView(viewModel: AddUpdateUserViewModel())
    }
}
