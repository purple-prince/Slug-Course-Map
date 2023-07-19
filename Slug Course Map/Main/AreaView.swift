//
//  AreaView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/16/23.
//

import SwiftUI
import FirebaseFirestore

struct AreaView: View {
    
    let areaTitle: String
    @State var allCourseCodes: [String] = []
    @State var areaCode: String = ""
    
    
}

extension AreaView {
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCourseCodes, id: \.self) { code in
                    NavigationLink(destination: CourseView(courseCode: "\(areaCode) \(code.lowercased())", areaTitle: areaTitle)) {//
                        Text("\(areaCode.uppercased()) \(code)")
                            .foregroundColor(.appPrimary)
                    }
                }
            }
            .navigationTitle(areaTitle)
        }
        .onAppear {
            getAreaDetails()
        }
    }
}

extension AreaView {
    
}

extension AreaView {
    func getAreaDetails() {
        let db = Firestore.firestore()
        db.collection("areasOfStudy").document(areaTitle).getDocument { snapshot, error in
            if let error = error { print(error.localizedDescription); return; }
            if let doc = snapshot {
                allCourseCodes = doc["classCodes"] as? [String] ?? ["Error :("]
                areaCode = (doc["code"] as? String ?? "Error")
            }
        }
    }
}

struct AreaView_Previews: PreviewProvider {
    static var previews: some View {
        AreaView(areaTitle: "Yiddish")
    }
}
