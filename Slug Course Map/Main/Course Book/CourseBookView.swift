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
                                .foregroundColor(.supaWhite)
                                
                        }
                        .listRowBackground(Color.supaDark28)
                        .preferredColorScheme(.dark)
                    }
                }
                .background(Color.supaDark)
                .scrollContentBackground(.hidden)
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
}

#Preview {
    CourseBookView(allAreasAndCodes: .constant([
        "Yiddish" : "YIDD",
        "Writing" : "YIDD",
        "Visualizing Abolitionist Studies" : "YIDD",
        "UCDC" : "YIDD",
        "Theater Arts" : "YIDD",
        "Technology Information Management" : "YIDD",
        "Stevenson College" : "YIDD",
        "Statistics" : "YIDD",
        "Spanish for Heritage Speakers" : "YIDD",
        "Spanish" : "YIDD",
        "Sociology" : "YIDD",
        "Social Documentation" : "YIDD",
        "Science Communication" : "YIDD"
    ]))
}
