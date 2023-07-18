//
//  ContentView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/10/23.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    
//    @State var allAreasOfStudy: [String] = []
//    @State var selectedAreaCourseCodes: [String] = []
//    @State var selectedAreaCode: String = ""
    @State var allAreasOfStudy: [String]
    @State var selectedAreaCourseCodes: [String]
    @State var selectedAreaCode: String
    
    init() {
        _allAreasOfStudy = State(initialValue: [])
        _selectedAreaCourseCodes = State(initialValue: [])
        _selectedAreaCode = State(initialValue: "")
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.appBlue)]
    }
    
}

extension ContentView {
    var body: some View {
        NavigationStack {
            
            
            VStack {
                List {
                    ForEach(allAreasOfStudy, id: \.self) { area in
                        NavigationLink(destination: AreaView(areaTitle: area)) {
                            Text(area)
                                .foregroundColor(.appBlue)
                        }
                    }
                    //.listRowBackground(Color(red: 0.85, green: 0.85, blue: 0.85))
                    
                }
                //.background(Color.appBlue)
                //.scrollContentBackground(.hidden)
            }
            .navigationTitle("Areas of Study")
        }
        .accentColor(.appBlue)
        .onAppear {
            loadAreasOfStudy()
        }
    }
}

extension ContentView {
    
}

extension ContentView {
    func loadAreasOfStudy() {
        let db = Firestore.firestore()

        let areasOfStudyRef = db.collection("areasOfStudy")
        areasOfStudyRef.document("meta").getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let doc = snapshot {
                DispatchQueue.main.async {
                    self.allAreasOfStudy = doc["allAreas"] as? [String] ?? ["Error"]
                }
            }
        }
    }
    
    func loadSelectedCourseCodes(forArea area: String) {
        let db = Firestore.firestore()
        
        db.collection("areasOfStudy").document(area).getDocument { snapshot, error in
            if let error = error { print(error.localizedDescription); return }
            if let doc = snapshot {
                selectedAreaCode = doc["code"] as? String ?? ""
                selectedAreaCourseCodes = doc["codes"] as? [String] ?? ["Error :("]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static let appYellow = Color(red: 1, green: 214/255, blue: 10/255)
    static let appBlue = Color(red: 0, green: 53/255, blue: 102/255)
}
