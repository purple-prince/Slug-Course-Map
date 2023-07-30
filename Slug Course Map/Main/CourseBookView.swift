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
    @Binding var allAreasOfStudy: [String]
    @State var selectedAreaCourseCodes: [String] = []
    @State var selectedAreaCode: String = ""
}

extension CourseBookView {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(allAreasOfStudy, id: \.self) { area in
                        NavigationLink(destination: AreaView(areaTitle: area, areaCode: selectedAreaCode)) {
                            Text(area)
                                .foregroundColor(.appPrimary)
                        }
                    }
                    
                }
            }
            .navigationTitle("Areas of Study")
        }
        .onAppear {
            if allAreasOfStudy.isEmpty {
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
                    self.allAreasOfStudy = doc["allAreas"] as? [String] ?? []
                }
            }
        }
    }
    
    // TODO: Unused
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

#Preview {
    CourseBookView(allAreasOfStudy: .constant([]))//areasHaveBeenCached: false)
}
