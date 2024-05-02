import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var CsearchText: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedVisibility: PostVisibility = .publicPost
    @State private var isFilterOptionsVisible = false
    @State private var isFiltersApplied = false
    @State private var countries: [String] = []
    @State private var selectedCountry: String?
    @State private var selectedCountries: [String] = []
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @State private var ishome = false
    
    //Filter selection text
    var selectedFiltersDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
            var description = ""
            description += "Start Date: \n"
            description += "End Date: \n"
            description += "Visibility: \(sharedViewModel.stripSearchPP)\n"
            description += "Selected Countries: \(sharedViewModel.stripSearchLoc.joined(separator: ", "))\n"

            return description
        }
    

    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    HStack {
                        HStack { //Search bar
                            TextField("", text: $sharedViewModel.tripSearch, prompt: Text("Search Trips").foregroundColor(.black))
                                .padding(8)
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                                .padding(.leading)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .padding(.leading)
                        }
                        //Search for trips button
                        HStack {
                            NavigationLink(destination: tripSearchView()){
                                Image(systemName: "magnifyingglass")
                                    .imageScale(.medium)
                                    .padding(.trailing, 8)
                                
                                
                            }
                            //Filters toggle button
                            Image(systemName: "slider.horizontal.3")
                                .imageScale(.medium)
                                .padding(.trailing, 16)
                                .onTapGesture {
                                    withAnimation {
                                        isFilterOptionsVisible.toggle()
                                    }
                                }
                        }
                        .foregroundColor(.black)
                    }
                    Text("Filters")
                        .font(.title)
                        .bold()
                        .underline()
                    Text(selectedFiltersDescription)
                        .padding()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .bold()

                    Button(action: { //Button to clear selected filters to search
                        sharedViewModel.stripSearchSD = Date()
                        sharedViewModel.stripSearchED = Date()
                        sharedViewModel.stripSearchPP = ""
                        sharedViewModel.stripSearchLoc = []
                    }) {
                        Text("Clear Filters")
                            .padding(.vertical, 5)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width / 1.25, height: 2)
                        .foregroundColor(.black)
                        .padding(.top)
                    
                    ZStack {
                        if isFilterOptionsVisible { //Show filter options if toggled
                            VStack {
                                Button(action: { //Button to apply selected filters to search
                                    isFilterOptionsVisible.toggle()
                                    isFiltersApplied.toggle()
                                    sharedViewModel.stripSearchSD = sharedViewModel.tripSearchSD
                                    sharedViewModel.stripSearchED = sharedViewModel.tripSearchED
                                    sharedViewModel.stripSearchPP = sharedViewModel.tripSearchPP
                                    sharedViewModel.stripSearchLoc = selectedCountries
                                }) {
                                    Text("Apply Filters")
                                        .padding(.vertical, 5)
                                        .foregroundColor(.white)
                                        .background(Color.black)
                                        .cornerRadius(10)
                                }
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("Start Date:")
                                        .padding(.trailing)
                                    
                                    DatePicker("", selection: $sharedViewModel.tripSearchSD, displayedComponents: .date)
                                        .labelsHidden()
                                }
                                
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("End Date:")
                                        .padding(.trailing)
                                    
                                    DatePicker("", selection: $sharedViewModel.tripSearchED, displayedComponents: .date)
                                        .labelsHidden()
                                }
                                HStack {
                                    Text("Trip type:")
                                        .padding(.trailing)
                                    
                                    Button(action: {
                                        selectedVisibility = .publicPost
                                        sharedViewModel.tripSearchPP = "Public"
                                    }) {
                                        CircleOptionViewSearch(option: "Public", isSelected: selectedVisibility == .publicPost, selectedColor: Color.black)
                                    }
                                    .padding()
                                    
                                    Button(action: {
                                        selectedVisibility = .privatePost
                                        sharedViewModel.tripSearchPP = "Private"
                                    }) {
                                        CircleOptionViewSearch(option: "Private", isSelected: selectedVisibility == .privatePost, selectedColor: Color.black)
                                    }
                                    .padding()
                                }
                                
                                VStack {
                                    Text("Selected Countries")
                                        .underline()
                                    HStack {
                                        Text(selectedCountries.joined(separator: ", "))
                                            .foregroundColor(.black)
                                            .padding(.trailing, 10)
                                    }
                                    .padding(.horizontal)
                                    //Country search bar
                                    TextField("", text: $CsearchText, prompt: Text("Search Countries").foregroundColor(.black))
                                        .padding(8)
                                        .cornerRadius(8)
                                        .padding(.horizontal, 10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
        
                                    List(filteredCountries, id: \.self) { country in
                                        HStack {
                                            CheckboxView(isChecked: selectedCountry == country) {
                                                if selectedCountries.contains(country) {
                                                    selectedCountries.removeAll { $0 == country }
                                                    sharedViewModel.locations.removeAll { String($0) == country }
                                                } else {
                                                    selectedCountries.append(country)
                                                    sharedViewModel.locations.append(country)
                                                }
                                                selectedCountry = nil
                                            }
                                            .padding(.trailing)
                                            
                                            Button(action: {
                                                selectedCountry = country
                                            }) {
                                                Text(country)
                                                    .padding(.vertical, 5)
                                            }
                                            .listRowBackground(Color.clear)
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width / 1.2)
                                    .cornerRadius(15)
                                    .listStyle(PlainListStyle())
                                    .onAppear {
                                        fetchCountries()
                                    }
                                }
                            }
                            .padding(.top,50)
                            .padding()
                            .cornerRadius(8)
                            .transition(.opacity)
                        }
                    }
                    .frame(height: 1000)
                    .foregroundColor(.black)
                    Spacer()
                }
        }
            .foregroundColor(.black)
            .fullScreenCover(isPresented: $ishome, content: {
                HomeView()
            })
        }
        .accentColor(.black)
    }

    private var filteredCountries: [String] {
        if CsearchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.localizedCaseInsensitiveContains(CsearchText) }
        }
    }
//Fetch countries from a country api
    private func fetchCountries() {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedData = try JSONDecoder().decode([Country].self, from: data)
                countries = decodedData.map { $0.name.common }
            } catch {
                print("Error fetching countries: \(error)")
            }
        }
    }
}
//Public or private selection
struct CircleOptionViewSearch: View {
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
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 0.5) 
                )
            Text(option)
                .font(.caption)
                .foregroundColor(.black)
                .foregroundColor(isSelected ? selectedColor : .black)
        }
    }
}

//Country list view with check boxes
struct CheckboxView: View {
    @State private var isChecked: Bool
    var action: () -> Void

    init(isChecked: Bool, action: @escaping () -> Void) {
        self._isChecked = State(initialValue: isChecked)
        self.action = action
    }

    var body: some View {
        Button(action: {
            isChecked.toggle()
            action()
        }) {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

private struct Country: Codable {
    var name: CountryName
}

private struct CountryName: Codable {
    var common: String
}

enum PostVisibility {
    case publicPost
    case privatePost
}
