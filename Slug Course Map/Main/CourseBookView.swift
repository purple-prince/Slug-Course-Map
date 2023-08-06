//
//  CourseBookView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/18/23.
//

import SwiftUI
import FirebaseFirestore
import SwiftData

struct CourseBookView: View {
    @Binding var allAreasAndCodes: [String : String]
    @State var showAreaView: Bool = false
}

extension CourseBookView {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(Array(allAreasAndCodes.keys).sorted().reversed(), id: \.self) { area in
                        NavigationLink(destination: AreaView(areaTitle: area, areaCode: allAreasAndCodes[area]!)) {
                            Text(area)
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
            }
            .navigationTitle("Areas of Study")
        }
        .onAppear {
            if allAreasAndCodes.isEmpty {
                loadAreasOfStudy()
            }
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
                    self.allAreasAndCodes = doc["allAreasAndCodes"] as? [String : String] ?? ["error" : "error"]
                }
            }
        }
    }
    
//    // TODO: Unused
//    func loadSelectedCourseCodes(forArea area: String) {
//        let db = Firestore.firestore()
//        
//        db.collection("areasOfStudy").document(area).getDocument { snapshot, error in
//            if let error = error { print(error.localizedDescription); return }
//            if let doc = snapshot {
//                selectedAreaCode = doc["code"] as? String ?? ""
//                selectedAreaCourseCodes = doc["codes"] as? [String] ?? ["Error :("]
//            }
//        }
//    }
}

//#Preview {
//    CourseBookView(allAreasOfStudy: .constant([]))//areasHaveBeenCached: false)
//}
