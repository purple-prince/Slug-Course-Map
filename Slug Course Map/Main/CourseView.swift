//
//  CourseView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/16/23.
//

import SwiftUI
import FirebaseFirestore
import SwiftData

struct CourseView: View {
    
    let courseCode: String
    @SwiftData.Query var selectedCourseDataArray: [CourseDataModel]
    @Environment(\.modelContext) var context
    
    @State var status: String = ""
    let areaTitle: String
    @State var course: Course?
//
//    @AppStorage("taken_credits") var taken_credits: Int = 0
//    @AppStorage("taking_credits") var taking_credits: Int = 0
//    
    @AppStorage("courses_status") var courses_status: [String : String] = [:]
    
    init(courseCode: String, areaTitle: String) {
        
        self.courseCode = courseCode
        self.areaTitle = areaTitle
                        
        _selectedCourseDataArray = SwiftData.Query(filter: #Predicate { $0.code == courseCode } )
                
    }
}

extension CourseView {
    var body: some View {
        ZStack {
            if let _ = course {
                courseDetails
                    .navigationBarTitleDisplayMode(.inline)
            }
            
        }
        .foregroundColor(.appPrimary)
        .onAppear {
            getCourseDetails()
            self.status = selectedCourseDataArray.first!.status
            print(self.status)
        }
        .onChange(of: status) { oldValue, newValue in
            selectedCourseDataArray.first!.status = newValue
        }
    }
}

extension CourseView {
    var courseDetails: some View {
        VStack {
            Picker("", selection: $status) {
                Text("avail").tag("available")
                Text("taken").tag("taken")
                Text("taking").tag("taking")
            }
            .pickerStyle(SegmentedPickerStyle())
//            .onAppear {
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    print("CODE: " + courseCode)
//                    print("HERE: " + courses_status[courseCode]!)
//                    courses_status[courseCode]! = courses_status[courseCode]!
//                }
//                
//                
//            }
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



//     // - - - - -
//     @State var status: String = "available"
//     @State var statusIsInitialized: Bool = false
//     // - - - - -
//
//         .onChange(of: status) { oldValue, newValue in
//             
//             if statusIsInitialized {
//                 if newValue == "available" {
//                     if oldValue == "taking" {
//                         taking_credits -= course!.credits
//                     } else if oldValue == "taken" {
//                         taken_credits -= course!.credits
//                     }
//                 } else if newValue == "taking" {
//                     if oldValue == "available" {
//                         taking_credits += course!.credits
//                     } else if oldValue == "taken" {
//                         taken_credits -= course!.credits
//                         taking_credits += course!.credits
//                     }
//                 } else if newValue == "taken" {
//                     if oldValue == "taking" {
//                         taking_credits -= course!.credits
//                         taken_credits += course!.credits
//                     } else if oldValue == "available" {
//                         taken_credits += course!.credits
//                     }
//                 }
//             }
//         }
//
// extension CourseView {
//     
//     var courseDetails: some View {
//         VStack {
//             VStack(spacing: 8) {
//                 Text(course!.title)
//                     .font(.largeTitle)
//                     .onTapGesture {
//                         print(courses_status[courseCode]!)
//                     }
//                 
//                 HStack {
//                     Text(courseCode.uppercased())
//                     
//                     Circle()
//                         .frame(width: 5)
//                     
//                     Text("\(course!.credits) credits")
//                 }
//             }
//                         
//             Text(course!.description)
//                 .font(.title3)
//                 .padding(.vertical, 48)
//                 .frame(maxWidth: .infinity, alignment: .leading)
//             
//             VStack(alignment: .leading, spacing: 8) {
//                 
//                 if let preReqs = course!.preReqCodes {
//                     Text("**Prerequisites:** \(preReqs)")
//                 }
//                 
//                 if let instructor = course!.instructor {
//                     Text("**Instructor:** \(instructor)")
//                 }
//                 
//                 if let genEdCode = course!.genEdCode {
//                     Text("**Gen Ed Code:** \(genEdCode.uppercased())")
//                 }
//                 
//                 if let qsOffered = course!.quartersOffered {
//                     Text("**Quarters Offered:** \(qsOffered)")
//                 }
//                 
//                 if let _ = course!.repeatableForCredit {
//                     Text("**Repeatable for Credit:** Yes")
//                 }
//                 
//                 HStack {
//                     Spacer()
//                 }
//             }
//             
//             Spacer()
//             
//             VStack {
//                 Text("Status")
//                     .font(.title)
//                     .bold()
//                 
// //                Picker("", selection: $status) {
// //                Picker("", selection: Bindable(selectedCourseDataArray.first!).status) {
//                 Picker("", selection: $courses_status[courseCode]) {
//                     
//                     Text("Available").tag(Optional("available"))
//                         .font(.largeTitle)
//                                         
//                     Text("Taking").tag(Optional("taking"))
//                     
//                     Text("Taken").tag(Optional("taken"))
//                     
//                 }
//                 .pickerStyle(SegmentedPickerStyle())
//                 .padding(.horizontal)
//                 .disabled(course == nil)
//             }
//         }
//         .padding()
//         
//     }
// }
//

//#Preview {
//    CourseView(courseCode: "writ 1", areaTitle: "Writing")
//        .modelContainer(previewContainer)
//}



