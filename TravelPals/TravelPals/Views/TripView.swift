import SwiftUI

struct TripView: View {
    @State private var isShowingMainView = false
    @ObservedObject var viewModel: AddUpdateUserViewModel
    @StateObject var postViewModel: AddUpdatePostViewModel
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @State private var isLiked = false
    @State private var isprofile = false
    
    var body: some View {
        ScrollView{
            ZStack{
                VStack {
                    if !isShowingMainView {
                        HStack{
                            Button(action: {
                                isShowingMainView.toggle()
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Spacer()
                            Button(action: { //Handle liking the post
                                if !sharedViewModel.postid.isEmpty {
                                    let idString = sharedViewModel.postid + ","
                                    if sharedViewModel.likedTrips.contains(idString) {
                                        sharedViewModel.likedTrips = sharedViewModel.likedTrips.replacingOccurrences(of: idString, with: "")
                                    } else {
                                        sharedViewModel.likedTrips += idString
                                    }
                                    print("Liked Trips: \(sharedViewModel.likedTrips)")
                                }
                            }){
                                Image(systemName: sharedViewModel.likedTrips.contains(sharedViewModel.postid) ? "heart.fill" : "heart")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                            }
                        }
                    }
                    getImage(for: sharedViewModel.tripname, description: sharedViewModel.description)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                    VStack{
                        Text(sharedViewModel.tripname)
                            .font(.custom("AvenirNext-Medium", size: 33))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                            .padding(.bottom,30)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color(red: 0.0, green: 0.3, blue: 0.0))
                    .clipShape(RoundedTopCorners(cornerRadius: 30))
                    .offset(y:-50)
                    VStack{ //Trip details
                        VStack{
                            HStack{
                                Text("Who?")
                                    .font(.system(size: 20))
                                    .bold()
                                    .padding(.leading)
                                    .padding(.top)
                                Spacer()
                            }
                            HStack{
                                Button(action: {
                                    isprofile.toggle()
                                }) {
                                    Text("Created by \(sharedViewModel.Tuser)")
                                        .bold()
                                        .padding(.leading)
                                    getImageP(for: sharedViewModel.Tuser)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                }//Present trip admin's profile when their username is clicked
                                .sheet(isPresented: $isprofile) {
                                    ScrollView {
                                        VStack {
                                            HStack{
                                                Text(sharedViewModel.Tfirstname)
                                                    .font(.largeTitle)
                                                    .offset(x: +20)
                                                Spacer()
                                            }
                                            HStack{
                                                Text(sharedViewModel.Tusername)
                                                    .font(.headline)
                                                    .offset(x: +20)
                                                Spacer()
                                            }
                                            if let selectedImage = sharedViewModel.selectedImage {
                                                selectedImage
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                                                    .clipped()
                                                    .clipShape(Rectangle())
                                                    .padding(5)
                                            } else {
                                                getImageP(for: sharedViewModel.Tusername)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                                                    .clipped()
                                                    .clipShape(Rectangle())
                                                    .padding(5)
                                            }
                                            VStack{
                                                HStack{
                                                    Text(sharedViewModel.Tage)
                                                        .font(.system(size: 15))
                                                        .padding(.horizontal, 20)
                                                    Spacer()
                                                }
                                                HStack{
                                                    Text(sharedViewModel.Tcountry)
                                                        .font(.system(size: 15))
                                                        .padding(.horizontal, 20)
                                                    Spacer()
                                                }
                                                Rectangle()
                                                    .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.0))
                                                    .frame(height: 3)
                                                    .padding(.horizontal, 16)
                                                Text("")
                                                HStack{
                                                    Spacer()
                                                    Text(sharedViewModel.Tbio)
                                                        .font(.system(size: 15))
                                                        .multilineTextAlignment(.leading)
                                                        .lineLimit(nil)
                                                        .padding(.horizontal, 5)
                                                    //.offset(x: +20)
                                                    Spacer()
                                                }
                                                Rectangle()
                                                    .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.0))
                                                    .frame(height: 3)
                                                    .padding(.horizontal, 16)
                                                Spacer()
                                                HStack{
                                                    Text("Interests")
                                                        .multilineTextAlignment(.center)
                                                        .font(.largeTitle)
                                                        .offset(x: +20)
                                                    Spacer()
                                                }
                                                VStack {
                                                    if !sharedViewModel.TselectedInterests.isEmpty {
                                                        let interestsArray = sharedViewModel.TselectedInterests.components(separatedBy: ",")
                                                        ForEach(interestsArray, id: \.self) { selectedInterest in
                                                            Text("- \(selectedInterest) -")
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .foregroundColor(.black)
                                        .background(Color.white)
                                        Spacer()
                                        
                                        Rectangle()
                                            .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.0))
                                            .frame(height: 3)
                                            .padding(.horizontal, 16)
                                        
                                    }
                                }
                                Spacer()
                                HStack{
                                    Text(postViewModel.privacy)
                                        .bold()
                                    if (sharedViewModel.privacy == "Private"){
                                        Image(systemName: "lock")
                                            .font(.system(size: 14))
                                            .bold()
                                    } else{
                                        Image(systemName: "lock.open")
                                            .font(.system(size: 14))
                                            .bold()
                                    }
                                }
                                .padding()
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        VStack{
                            HStack{
                                Text("When?")
                                    .font(.system(size: 20))
                                    .bold()
                                    .padding(.leading)
                                    .padding(.top)
                                Spacer()
                            }
                            HStack{
                                Image(systemName: "calendar")
                                    .font(.system(size: 14))
                                    .bold()
                                    .padding(.leading)
                                Text("\(formattedDate(from: sharedViewModel.startDate)) - \(formattedDate(from: sharedViewModel.endDate))")
                                    .bold()
                                    .padding(.bottom)
                                    .padding(.top)
                                Spacer()
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        Spacer()
                        VStack{
                            HStack{
                                Text("Where?")
                                    .font(.system(size: 20))
                                    .bold()
                                    .padding(.leading)
                                    .padding(.top)
                                Spacer()
                            }
                            HStack{
                                Image(systemName: "mappin")
                                    .font(.system(size: 14))
                                    .bold()
                                    .padding(.leading)
                                Text(sharedViewModel.locations)
                                    .bold()
                                Spacer()
                            }
                        }
                        .padding(.bottom)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.125)
                    .foregroundColor(.white)
                    .background(Color(red: 0.0, green: 0.3, blue: 0.0))
                    .padding(.bottom,100)
                    Spacer()
                    VStack{
                        HStack{
                            Text("What?")
                                .font(.system(size: 20))
                                .bold()
                                .padding(.leading)
                                .padding(.top)
                            Spacer()
                        }
                        HStack{
                            Text(sharedViewModel.description)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .foregroundColor(.white)
                    .padding(.top)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    if(sharedViewModel.privacy == "Private"){
                        Button(action: {
                            openWhatsAppGroupChat()
                        }) {
                            Text("Request to join this trip")
                                .frame(width: 180, height: 50)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    } else {
                        Button(action: {
                            openWhatsAppGroupChat()
                        }) {
                            Text("Join this trip")
                                .frame(width: 180, height: 50)
                                .foregroundColor(.white)
                            .cornerRadius(10)                    }
                        Spacer()
                    }
                }
            }
            .background(Color(red: 0.0, green: 0.3, blue: 0.0))
        }
        //Fetch all needed details when view appears
        .onAppear{
            Task {
                do {
                    if let user = try await viewModel.fetchUserDetails(username: sharedViewModel.Tuser) {
                        sharedViewModel.Tfirstname = user.name
                        sharedViewModel.Tusername = user.username
                        sharedViewModel.Tage = user.age
                        sharedViewModel.Tbio = user.bio
                        sharedViewModel.Tcountry = user.country
                        sharedViewModel.TselectedInterests = user.interests
                    }
                } catch {
                    print("Error fetching additional user details: \(error)")
                }
            }
        }
        .background(Color(red: 0.0, green: 0.3, blue: 0.0))
        .fullScreenCover(isPresented: $isShowingMainView, content: {
            HomeView()
        })
    }
    //Fetch whatsapp group
    private func openWhatsAppGroupChat() {
        if let url = URL(string: sharedViewModel.whatsapp), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    //Fetch liked posts
    private func fetchLikedPosts(username: String) {
        Task {
            do {
                if let user = try await viewModel.fetchUserDetails(username: username) {
                    if let likedPosts = user.likedposts {
                        print("Liked Posts: \(likedPosts)")
                    } else {
                        print("No liked posts found.")
                    }
                }
            } catch {
                print("Error fetching additional user details: \(error)")
            }
        }
    }
    //Format date
    func formattedDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: String(dateString.prefix(10))) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedString = dateFormatter.string(from: date)
            return formattedString
        }
        
        return ""
    }
    //Choose Image based of text in post
    private func getImage(for tripName: String, description: String) -> Image {
        if tripName.contains("ski") || description.contains("ski") {
            return Image("ski")
        } else if tripName.contains("asia") || description.contains("Asia") {
            return Image("asia")
        } else if tripName.contains("surf") || description.contains("surf") {
            return Image("surf")
        } else if tripName.contains("hiking") || description.contains("hiking") {
            return Image("hiking")
        } else if tripName.contains("Africa") || description.contains("Africa") {
            return Image("africa")
        } else if tripName.contains("interrail") || description.contains("interrail") {
            return Image("interrail")
        } else if tripName.contains("museum") || description.contains("museum") {
            return Image("mus")
        } else {
            return Image("beach")
        }
    }
    //Current state a default image is chosen for profiles (In future users can choose their own profile images)
    private func getImageP(for userr: String) -> Image {
        if sharedViewModel.Tusername == "SamuelChat" {
            return Image("Samuel")
        } else if sharedViewModel.Tusername == "Emiryyy" {
            return Image("Emiryyy")
        } else if sharedViewModel.Tusername == "Sammyyy" {
            return Image("me")
        } else if sharedViewModel.Tusername == "EmmaBee" {
            return Image("EmmaBee")
        } else if sharedViewModel.Tusername == "MichaelPort" {
            return Image("mic")
        } else if sharedViewModel.Tusername == "BenPrance" {
            return Image("ben")
        } else {
            return Image("me")
        }
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(viewModel: AddUpdateUserViewModel(), postViewModel: AddUpdatePostViewModel())
    }
}

