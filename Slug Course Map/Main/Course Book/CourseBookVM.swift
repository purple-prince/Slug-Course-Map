//
//  CourseBookVM.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/26/23.
//

import Foundation
import FirebaseFirestore

class CourseBookVM: ObservableObject {
    
    @Published var allAreasOfStudy: [String] = []
    
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
}
