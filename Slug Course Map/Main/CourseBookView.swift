//
//  CourseBookView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/18/23.
//

import SwiftUI
import FirebaseFirestore

struct CourseBookView: View {
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

extension CourseBookView {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(allAreasOfStudy, id: \.self) { area in
                        NavigationLink(destination: AreaView(areaTitle: area)) {
                            Text(area)
                                .foregroundColor(.appPrimary)
                        }
                    }
                    
                }
            }
            .navigationTitle("Areas of Study")
        }
        .onAppear {
            loadAreasOfStudy()
        }
    }
}

extension CourseBookView {
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

struct CourseBookView_Previews: PreviewProvider {
    static var previews: some View {
        CourseBookView()
    }
}
