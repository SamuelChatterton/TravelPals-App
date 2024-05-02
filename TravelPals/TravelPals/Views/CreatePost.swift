import SwiftUI
import CoreData

struct PostDB: View {
    enum PostVisibility {
        case publicPost
        case privatePost
    }

    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @ObservedObject var viewModel: AddUpdateUserViewModel
    @ObservedObject var postViewModel: AddUpdatePostViewModel

    @State private var tripname = ""
    @State private var description: String = ""
    @State private var postVisibility: PostVisibility = .publicPost
    @State private var privacy: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var location = ""
    
    @State private var titleError = ""
    @State private var descriptionError = ""
    @State private var countryError = ""
    @State private var whatsappError = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Trip Name", text: $postViewModel.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Text(titleError)
                .foregroundColor(.red)
                .font(.system(size: 15))
            
            TextEditor(text: $postViewModel.description)
                .frame(height: 150)
                .foregroundColor(.black)
                .opacity(0.7)
                .cornerRadius(10)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                )
            Text(descriptionError)
                .foregroundColor(.red)
                .font(.system(size: 15))
            
            HStack {
                Text("Trip type:")
                    .padding(.trailing)
                    .foregroundColor(.black)
                
                Button(action: {
                    postVisibility = .publicPost
                    postViewModel.privacy = "Public"
                }) {
                    CircleOptionView(option: "Public", isSelected: postVisibility == .publicPost, selectedColor: Color.black)
                }
                .padding()
                
                Button(action: {
                    postVisibility = .privatePost
                    postViewModel.privacy = "Private"
                }) {
                    CircleOptionView(option: "Private", isSelected: postVisibility == .privatePost, selectedColor: Color.black)
                }
                .padding()
            }
            
            HStack {
                Image(systemName: "calendar")
                Text("Start Date:")
                    .padding(.trailing)
                
                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .labelsHidden()
            }
            .foregroundColor(.black)
            
            HStack {
                Image(systemName: "calendar")
                Text("End Date:")
                    .padding(.trailing)
                
                DatePicker("", selection: $endDate, displayedComponents: .date)
                    .labelsHidden()
            }
            .foregroundColor(.black)
            
            TextField("Country", text: $postViewModel.locations)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text(countryError)
                .foregroundColor(.red)
                .font(.system(size: 15))
            
            HStack {
                TextField("WhatsApp Link", text: $postViewModel.whatsapp)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Text(whatsappError)
                .foregroundColor(.red)
                .font(.system(size: 15))
            
            Button(action: {
                   let isoStartDate = ISO8601StringFromDate(date: startDate) //Handle date format
                   let isoEndDate = ISO8601StringFromDate(date: endDate)
                    postViewModel.startDate = isoStartDate
                    postViewModel.endDate = isoEndDate
                
                if validateInputs() { //Check inputs
                    postViewModel.addUpdateAction { //Save post to database
                        clearInputFields()
                    }
                }
            }) {
                Text("Create Post")
                    .frame(width: 200, height: 50)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(10)
            }
    }
        .padding()
       .onAppear {
                postViewModel.user = sharedViewModel.username
            }
    }

    func clearInputFields() {
        tripname = ""
        description = ""
        startDate = Date()
        endDate = Date()
        description = ""
        location = ""
    }
    
    private func validateInputs() -> Bool {
        //Reset error messages
        titleError = ""
        descriptionError = ""
        countryError = ""
        whatsappError = ""

        var isValid = true

        //Validate title
        if postViewModel.title.isEmpty {
            titleError = "Please enter a title."
            isValid = false
        }
        
        if postViewModel.title.count < 3 {
            titleError = "Please enter a valid title."
            isValid = false
        }
        
        //Validate description
        if postViewModel.description.count < 100 {
            descriptionError = "Description must be at least 60 characters."
            isValid = false
        }
        
        if postViewModel.description.isEmpty {
            descriptionError = "Please enter a description."
            isValid = false
        }
        
        //Validate country
        if postViewModel.locations.isEmpty {
            titleError = "Please enter a location."
            isValid = false
        }
        
        //Validate link
        if postViewModel.whatsapp.isEmpty {
            titleError = "Please enter a WhatsApp Group chat link."
            isValid = false
        }
        
        return isValid
    }
}

//Handle public or private selection display
struct CircleOptionView: View {
    let option: String
    let isSelected: Bool
    let selectedColor: Color

    var body: some View {
        VStack {
            Circle()
                .fill(isSelected ? selectedColor : Color.white)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle()
                        .stroke(selectedColor, lineWidth: 2)
                        .opacity(isSelected ? 1 : 0)
                )
            Text(option)
                .font(.caption)
                .foregroundColor(isSelected ? selectedColor : .black)
        }
    }
}
//Formate date to correct format for database
func ISO8601StringFromDate(date: Date) -> String {
    let isoDateFormatter = ISO8601DateFormatter()
    return isoDateFormatter.string(from: date)
}

struct PostDB_Previews: PreviewProvider {
    static var previews: some View {
        PostDB(viewModel: AddUpdateUserViewModel(), postViewModel: AddUpdatePostViewModel())
    }
}
