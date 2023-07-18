//
//  CourseView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/16/23.
//

import SwiftUI
import FirebaseFirestore

struct Course: Identifiable {
    let id = UUID().uuidString
    
    let title: String
    let code: String
    let credits: Int
    let description: String
    let quartersOffered: String?
    let instructor: String?
    let genEdCode: String?
    let repeatableForCredit: Bool?
    let preReqCodes: String?
}

struct CourseView: View {
    let courseCode: String
    let areaTitle: String
    @State var course: Course?
}

extension CourseView {
    var body: some View {
        ZStack {
            if let _ = course {
                courseDetails
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .onAppear {
            print(courseCode)
            getCourseDetails()
        }
        .foregroundColor(.appBlue)
    }
}
extension CourseView {
    var courseDetails: some View {
        VStack {
            VStack(spacing: 8) {
                Text(course!.title)
                    .font(.largeTitle)
                
                HStack {
                    Text(courseCode.uppercased())
                    Circle()
                        .frame(width: 5)
                    
                    Text("\(course!.credits) credits")
                }
            }
                        
            Text(course!.description)
                .font(.title3)
                .padding(.vertical, 48)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                
                if let preReqs = course!.preReqCodes {
                    HStack(spacing: 0) {
                        Text("**Prerequisites:** ")
                        Text(preReqs)
                    }
                }
                
                if let instructor = course!.instructor {
                    HStack(spacing: 0) {
                        Text("**Instructor:** ")
                        Text(instructor)
                    }
                }
                
                if let genEdCode = course!.genEdCode {
                    HStack(spacing: 0) {
                        Text("**Gen Ed Code:** ")
                        Text(genEdCode.uppercased())
                    }
                }
                
                if let qsOffered = course!.quartersOffered {
                    HStack(spacing: 0) {
                        Text("**Quarters Offered:** ")
                        Text(qsOffered)
                    }
                }
                
                if let _ = course!.repeatableForCredit {
                    HStack(spacing: 0) {
                        Text("**Repeatable for Credit:** ")
                        Text("Yes")
                    }
                }
                
                HStack {
                    Spacer()
                }
            }
            
            
            Spacer()
        }
        .padding()
    }
}

extension CourseView {
    func getCourseDetails() {
        let db = Firestore.firestore()
        db.collection("areasOfStudy").document(areaTitle).collection("courses").document(courseCode)
            .getDocument { snapshot, error in
                if let doc = snapshot {
                    course = Course(
                        title: doc["title"] as? String ?? "Error",
                        code: courseCode,
                        credits: doc["credits"] as? Int ?? -1,
                        description: doc["description"] as? String ?? "Error",
                        quartersOffered: doc["qsOffered"] as? String,
                        instructor: doc["instructor"] as? String,
                        genEdCode: doc["genEdCode"] as? String,
                        repeatableForCredit: doc["repeatableForCred"] as? Bool,
                        preReqCodes: doc["prereqs"] as? String
                    )
                }
        }
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView(courseCode: "yidd 99f", areaTitle: "Yiddish")
    }
}
