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
//    @SwiftData.Query var selectedCourseDataArray: [CourseDataModel]
    @Query var selectedCourseDataArray: [CourseDataModel] // MARK: here
    
    @Environment(\.modelContext) var context
    
    @State var status: String = ""
    let areaTitle: String
    @State var course: Course?
    
    // course rate popup
    @State var showRateCoursePopup: Bool = false
    @State var difficultyStars: Int = 0
    @State var satisfactionStars: Int = 0

    @AppStorage("taken_credits") var taken_credits: Int = 0
    @AppStorage("taking_credits") var taking_credits: Int = 0
    @AppStorage("completed_courses") var completed_courses: [String] = []
    
    
    @Binding var showCourseView: Bool
    
    init(courseCode: String, areaTitle: String, showCourseView: Binding<Bool>) {
        
        self.courseCode = courseCode
        self.areaTitle = areaTitle
                        
        _selectedCourseDataArray = SwiftData.Query(filter: #Predicate { $0.code == courseCode } )
                
        self._showCourseView = Binding(projectedValue: showCourseView)
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
        .navigationBarBackButtonHidden(true)
        .foregroundColor(.appPrimary)
        .onAppear {
            getCourseDetails()
            self.status = selectedCourseDataArray.first!.status
        }
        .onChange(of: status) { oldValue, newValue in
            
            guard oldValue != "" else { return }
            
            selectedCourseDataArray.first!.status = newValue
            
            if newValue == "available" {
                if oldValue == "taking" {
                    taking_credits -= course!.credits
                } else if oldValue == "taken" {
                    taken_credits -= course!.credits
                    completed_courses.removeAll { course in
                        course == courseCode
                    }
                }
            } else if newValue == "taking" {
                if oldValue == "available" {
                    taking_credits += course!.credits
                } else if oldValue == "taken" {
                    taken_credits -= course!.credits
                    taking_credits += course!.credits
                    completed_courses.removeAll { course in
                        course == courseCode
                    }
                }
            } else if newValue == "taken" {
                if oldValue == "taking" {
                    taking_credits -= course!.credits
                    taken_credits += course!.credits
                    completed_courses.append(course!.code)
                } else if oldValue == "available" {
                    taken_credits += course!.credits
                    completed_courses.append(course!.code)
                }
            }
            
            HapticManager.manager.playHaptic(type: .light)
            
        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.showCourseView = false
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                        Text(areaTitle)
                    }
                }
            }
        }
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
 extension CourseView {
     
     var courseDetails: some View {
         ZStack {
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
                     
                     if let preReqs = course!.preReqCodes { Text("**Prerequisites:** \(preReqs)") }
                     
                     if let instructor = course!.instructor { Text("**Instructor:** \(instructor)") }
                     
                     if let genEdCode = course!.genEdCode { Text("**Gen Ed Code:** \(genEdCode.uppercased())") }
                     
                     if let qsOffered = course!.quartersOffered { Text("**Quarters Offered:** \(qsOffered)") }
                     
                     if let _ = course!.repeatableForCredit { Text("**Repeatable for Credit:** Yes") }
                     
                     Spacer()
                 }
                 .frame(maxWidth: .infinity)
                 
                 VStack(alignment: .leading) {
                     Rectangle()
                         .frame(height: 2)
                        
                     HStack {
                         Text("Reviews")
                         
                         VStack(alignment: .leading) {
                             Text("4.3 / 5")
                             
                             ForEach(1..<6) { num in
                                 Image("star")
                                     .foregroundStyle(.yellow)
                             }
                         }
                     }
                     
                     Button(action: {
                         showRateCoursePopup = true
                     }) {
                         Text("Rate Course")
                     }
                 }
                 
                 Spacer()
                 
                 
                 
                 VStack {
                     Text("Status")
                         .font(.title)
                         .bold()

                     Picker("", selection: $status) {

                         Text("Available").tag("available")
                             .font(.largeTitle)
                                             
                         Text("Taking").tag("taking")
                         
                         Text("Taken").tag("taken")
                         
                     }
                     .pickerStyle(SegmentedPickerStyle())
                     .padding(.horizontal)
                     .disabled(course == nil)
                 }
             }
             .padding()
             
             if showRateCoursePopup {
                 rateCoursePopup
             }
         }
     }
     
     func submitCourseReview(areaTitle: String, courseName: String, review: Review) {
         let db = Firestore.firestore()
         db.collection("areasOfStudy")
             .document(areaTitle)
             .collection("courses")
             .document(courseName)
             .updateData([
                 "numReviews" : FieldValue.increment(1.0),
                 "totalDifficultyStars" : FieldValue.increment(review.difficultyStars),
                 "totalSatisfactionStars" : FieldValue.increment(review.satisfactionStars),
                 //"allReviews" : append to firestore array...
             ])
     }
     
     var rateCoursePopup: some View {
         ZStack {
             RoundedRectangle(cornerRadius: 12)
                 .foregroundStyle(.white)
                 .blur(radius: 12) //test change
             
             VStack {
                 
                 Image(systemName: "xmark")
                     .font(.title)
                     .onTapGesture {
                         showRateCoursePopup = false
                     }
                 
                 Text("Write a review")
                     .font(.title)
                 
                 VStack {
                     HStack {
                         Text("Difficulty")
                         
                         HStack {
                             ForEach(1..<6) { num in
                                 Image(systemName: difficultyStars >= num ? "star.fill" : "star")
                                     .foregroundStyle(.yellow)
                                     .onTapGesture {
                                         if difficultyStars != num {
                                             difficultyStars = num
                                         } else {
                                             difficultyStars -= 1
                                         }
                                         
                                         HapticManager.manager.playHaptic(type: .soft)
                                     }
                             }
                         }
                     }
                     
                     HStack {
                         Text("Satisfaction")
                         
                         HStack {
                             ForEach(1..<6) { num in
                                 Image(systemName: satisfactionStars >= num ? "star.fill" : "star")
                                     .foregroundStyle(.yellow)
                                     .onTapGesture {
                                         if satisfactionStars != num {
                                             satisfactionStars = num
                                         } else {
                                             satisfactionStars -= 1
                                         }
                                         
                                         HapticManager.manager.playHaptic(type: .soft)
                                     }
                             }
                         }
                     }
                     
                     Button(action: {
                         
                         if difficultyStars > 0 && satisfactionStars > 0 {
                             let review = Review(difficultyStars: Double(difficultyStars), satisfactionStars: Double(satisfactionStars))
                             submitCourseReview(areaTitle: "", courseName: "", review: review)
                         }
                     }) {
                         Text("Submit")
                             .font(.title2)
                             .padding()
                             .background(
                                 RoundedRectangle(cornerRadius: 12)
                                     .foregroundStyle(Color.appBlue)
                             )
                     }
                 }
             }
             .foregroundStyle(Color.appBlue)
             .padding()
         }
     }
 }


//#Preview {
//    CourseView(courseCode: "writ 1", areaTitle: "Writing")
//        .modelContainer(previewContainer)
//}



