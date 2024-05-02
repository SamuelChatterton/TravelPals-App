//SharedViewModel Variables
import SwiftUI
import CoreData

class SharedViewModel: ObservableObject {
    @Published var username = ""
    @Published var firstname = ""
    @Published var age = ""
    @Published var country = ""
    @Published var bio = ""
    @Published var selectedImage: Image?
    @Published var selectedInterests = ""
    @Published var user: String = ""
    @Published var tripname = ""
    @Published var description: String = ""
    @Published var privacy: String = ""
    @Published var startDate: String = ""
    @Published var endDate: String = ""
    @Published var locations: String = ""
    @Published var whatsapp: String = ""
    @Published var postid = ""
    @Published var loginInterests: [String] = []
    @Published var sim: Double = 0
    @Published var tripSearch: String = ""
    @Published var tripSearchSD: Date
    @Published var tripSearchED: Date
    @Published var tripSearchPP: String = ""
    @Published var tripSearchLoc: [String] = []
    @Published var colour: Color?
    @Published var likedTrips: String = ""
    @Published var likedTripsList: [String] = []
    
    @Published var Tuser = "" //T at the front variables are variables for viewing a user profile from trip view
    @Published var Tusername = ""
    @Published var Tfirstname = ""
    @Published var Tage = ""
    @Published var Tcountry = ""
    @Published var Tbio = ""
    @Published var TselectedImage: Image?
    @Published var TselectedInterests = ""
    
    @Published var stripSearchSD: Date? //Filtering varaibles
    @Published var stripSearchED: Date?
    @Published var stripSearchPP: String = ""
    @Published var stripSearchLoc: [String] = []
    
    init() {
        self.tripSearchSD = Date()
        self.tripSearchED = Date()
        self.stripSearchSD = Date()
        self.stripSearchED = Date()
    }
}

