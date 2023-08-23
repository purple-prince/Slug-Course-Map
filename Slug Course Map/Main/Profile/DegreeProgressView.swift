//
//  DegreeProgressView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 8/22/23.
//

import SwiftUI
import FirebaseFirestore
import SwiftData

struct DegreeProgressView: View {
    @Binding var showDegreeProgressView: Bool
    
    @State var allMajors: [String] = []
    @AppStorage("completed_courses") var completed_courses: [String] = []
}

extension DegreeProgressView {
    var body: some View {
        ZStack {
            backButton
            
            VStack {
                
                Text("Degree Progress")
                    .font(.largeTitle)
                    .bold()
                    .onTapGesture {
                        print(completed_courses.description)
                    }
                
                if !allMajors.isEmpty {
                    ScrollView {
                        VStack {
                            ForEach(allMajors, id: \.self) { major in
                                DegreeItemCard(title: major)
                            }
                        }
                    }
                    
                } else {
                    Spacer()
                }
            }
            .foregroundColor(.appPrimary)
            .padding(.init(top: 10, leading: 16, bottom: 16, trailing: 16))
        }
        .onAppear {
            getAllDegreeNames()
        }
       
    }
}

struct DegreeItemCard: View {
    
    let title: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                
                HStack {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .stroke(Color.appBlue, lineWidth: 2)

                        Rectangle()
                            .fill(Color.appBlue)
                            .frame(width: 200)
                    }
                    .frame(width: 250, height: 16)
                    .clipShape(Capsule())
                    
                    Text("66%")
                        .font(.title3)
                        .padding(.horizontal)
                }

                Capsule()
                    .frame(width: UIScreen.main.bounds.width - 32, height: 1)
                    //.frame(width: .infinity, height: 1)
            }
        }
    }
}

extension DegreeProgressView {
    
    var backButton: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.appPrimary)
                    .onTapGesture {
                        showDegreeProgressView = false
                    }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding()
    }
}

extension DegreeProgressView {
    func getAllDegreeNames() {
        let db = Firestore.firestore()
        
        db.collection("degree").document("undergradDegreeInfo").getDocument { snapshot, error in
            if let error = error { print(error.localizedDescription); return }
            if let doc = snapshot {
                allMajors.append(contentsOf: ["UC Requirements", "Gen Ed Requirements"])
                self.allMajors.append(contentsOf: doc["majorsOffered"] as? [String] ?? ["Error"])
            }
        }
    }
    
    func determineAgroecology() -> Double {
        
        let db = Firestore.firestore()
        db.collection("degree")
            .document("undergradDegreeInfo")
            .collection("undergradMajors")
            .document("argoecology")
            .getDocument { snapshot, error in
                if let error = error { print(error.localizedDescription); return }
                if let doc = snapshot {
                    let encodedReqs = doc["courseReqs"] as? [String] ?? ["Error"]
                    var hasFailed = false
                    
                    for req in encodedReqs {
                        if !requirementPassed(req: req) {
                            
                        }
                    }
                    
                }
            }
        
        return 0
    }
    
    
    
    func requirementPassed(req: String) -> Bool {
        
        if req.hasPrefix("either") {
            
            // either stat 7 and stat 7l or stat 17 and stat 17l
            
            let joinedReqs = req.deletingPrefix("either ")
            // stat 7 and stat 7l or stat 17 and stat 17l
            
            let strReqSets = joinedReqs.components(separatedBy: " or ")
            // ["stat 7 and stat 7l", "stat 17 and stat 17l"]
            
            let reqSets = strReqSets.map { reqs in
                return reqs.components(separatedBy: " and ")
            }
            // [["stat 7", "stat 7l"], ["stat 17", ["stat 17l"]]
            
            
            for reqSet in reqSets {
                if !(reqSet.filter({ course in
                    return requirementPassed(req: course)
                }).isEmpty) {
                    return true
                }
            }
            
            return false
            
        } else if req.contains(" or ") {
            
            let courses = Set(req.components(separatedBy: " or "))
            let satisfiedCourses = courses.intersection(completed_courses)
            return !satisfiedCourses.isEmpty
            
        } else {
            return completed_courses.contains(req)
        }
    }
}

#Preview {
    DegreeProgressView(showDegreeProgressView: .constant(false))
}


