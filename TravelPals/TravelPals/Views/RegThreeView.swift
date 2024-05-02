import SwiftUI

struct RegThreeView: View {
    @ObservedObject var viewModel: AddUpdateUserViewModel
    @State private var searchText: String = ""
    @State private var progress: Double = 0.6
    @State private var countries: [String] = []
    @State private var selectedCountry: String?
    @State private var isRegFourViewPresented = false
    @State private var isRegTwoViewPresented = false
    @State private var count: Int = 0
    @State private var ageError = ""

    var body: some View {
        ZStack {
            Image("MS1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                if !isRegTwoViewPresented {
                    HStack{
                        Spacer()
                        Button(action: { //Go to previous page
                            isRegTwoViewPresented.toggle()
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
                    TextField("", text: $searchText, prompt: Text("Search Country").foregroundColor(.white))
                        .frame(width: UIScreen.main.bounds.width / 1.75, height: 20)
                        .foregroundColor(.white)
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width / 1.75, height: 3)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8013854623, green: 0.4860467911, blue: 0.9110258222, alpha: 1)), Color(#colorLiteral(red: 0.1228386536, green: 0.9390388131, blue: 0.8726419806, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                        )
                        .padding(.bottom, 5)

                    List(filteredCountries, id: \.self) { country in
                        Button(action: {
                            selectedCountry = country
                        }) {
                            Text(country)
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .onAppear {
                        fetchCountries()
                    }
                    .background(Color.clear)

                    Button(action: {
                        if let selectedCountry = selectedCountry {// Check selection
                            viewModel.country = selectedCountry
                            isRegFourViewPresented.toggle() //Go to next step
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
                    .fullScreenCover(isPresented: $isRegTwoViewPresented, content: {
                        RegTwoView(viewModel: viewModel) //Go to previous page
                    })
                    .fullScreenCover(isPresented: $isRegFourViewPresented) {
                        RegFourView(viewModel: viewModel) //Go to next page
                    }
                }
                .frame(width: 300, height: 500)
                .opacity(1)
                .cornerRadius(15)
            }
        }
        .transition(.opacity)
        .onChange(of: selectedCountry) { newCountry in
            searchText = newCountry ?? ""
        }
        
    }

    private var filteredCountries: [String] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    //Fetch countries from countries api
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

struct RegThreeView_Previews: PreviewProvider {
    static var previews: some View {
        RegThreeView(viewModel: AddUpdateUserViewModel())
    }
}

private struct Country: Codable {
    var name: CountryName
}

private struct CountryName: Codable {
    var common: String
}


