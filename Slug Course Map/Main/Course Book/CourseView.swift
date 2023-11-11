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
    @Query var selectedCourseDataArray: [CourseDataModel] // MARK: here
    
    @Environment(\.modelContext) var context
    
    @State var status: String = ""
    let areaTitle: String
    @State var course: Course?
    
    // course rate popup
    @State var showRateCoursePopup: Bool = false
    @State var difficultyStars: Double = 0
    @State var satisfactionStars: Double = 0
    @State var totalReviews: Double = 0
    var difficultyRating: Double { return difficultyStars / [totalReviews, 1].max()! }
    var satisfactionRating: Double { return satisfactionStars / [totalReviews, 1].max()! }
    
    @AppStorage("taken_credits") var taken_credits: Int = 0
    @AppStorage("taking_credits") var taking_credits: Int = 0
    @AppStorage("completed_courses") var completed_courses: [String] = []
    
    @Binding var showCourseView: Bool
    
    init(courseCode: String, areaTitle: String, showCourseView: Binding<Bool>) {
        
        self.courseCode = courseCode
        self.areaTitle = areaTitle
                        
        _selectedCourseDataArray = SwiftData.Query(filter: #Predicate { $0.code == courseCode } )
                
        self._showCourseView = Binding(projectedValue: showCourseView)
        
        UISegmentedControl.appearance().backgroundColor = UIColor(Color(red: 45/255, green: 45/255, blue: 45/255))
    }
}

extension CourseView {
    var body: some View {
        ZStack {
            Color.supaDark.ignoresSafeArea()
            
            if let _ = course {
                courseDetails
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationBarBackButtonHidden(true)
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
    var reviews: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(Color.supaDark28)
            
            VStack(alignment: .leading) {
                HStack {
                    
                    Text("Reviews (\(Int(totalReviews)))")
                        .font(.tTitle2)
                        .bold()
                        .foregroundStyle(Color.supaWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        showRateCoursePopup = true
                    }) {
                        Text("Rate Course")
                            .foregroundStyle(.teal)
                    }
                }
                .padding(.bottom)
                
                
                HStack {
                    Text("Difficulty")
                        .foregroundStyle(Color.supaWhite)
                        
                    
                    Spacer()
                    
                    
                    Text("\((difficultyStars / [totalReviews, 1].max()!).description) / 5")
                        .font(.custom("Titillium-SemiBold", size: 17))
                        .foregroundStyle(Color.supaWhite)
                    
                    ZStack(alignment: .leading) {
                        
                        Rectangle()
                            .fill(Color.supaGreen)
                            .frame(width: CGFloat(difficultyRating) * 20)
                        
                        Capsule()
                            .stroke(Color.supaGreen, lineWidth: 2)
                    }
                    .frame(width: 100, height: 16)
                    .clipShape(Capsule())
                }
                .font(.tTitle3)
                
                HStack {
                    Text("Satisfaction")
                        .foregroundStyle(Color.supaWhite)
                        .onTapGesture {
                            print(satisfactionRating.description)
                        }
                    
                    Spacer()
                    
                    Text("\((satisfactionStars / [totalReviews, 1].max()!).rounded(to: 2).description) / 5")
                        .fontWeight(.medium)
                        .font(.custom("Titillium-SemiBold", size: 17))
                        .foregroundStyle(Color.supaWhite)
                    
                    ZStack(alignment: .leading) {
                        
                        Rectangle()
                            .fill(Color.supaGreen)
                            .frame(width: CGFloat(satisfactionRating) * 20)
                        
                        Capsule()
                            .stroke(Color.supaGreen, lineWidth: 2)
                    }
                    .frame(width: 100, height: 16)
                    .clipShape(Capsule())
                    
                    
                }
                .font(.tTitle2)
            }
        }
    }
    
    var courseDetails: some View {
        ZStack {
            
            VStack {
                ScrollView {
                    VStack(spacing: 8) {
                        Text(course!.title)
                            .font(.tTitle)
                        
                        HStack {
                            Text(courseCode.uppercased())
                            
                            Circle()
                                .frame(width: 5)
                            
                            Text("\(course!.credits) credits")
                        }
                    }
                    .foregroundStyle(Color.supaWhite)
                                
                    Text(course!.description)
                        .font(.tBody)
                        .padding(.vertical, 48)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.supaWhite)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        if let preReqs = course!.preReqCodes { Text("**Prerequisites:** \(preReqs)") }
                        
                        if let instructor = course!.instructor { Text("**Instructor:** \(instructor)") }
                        
                        if let genEdCode = course!.genEdCode { Text("**Gen Ed Code:** \(genEdCode.uppercased())") }
                        
                        if let qsOffered = course!.quartersOffered { Text("**Quarters Offered:** \(qsOffered)") }
                        
                        if let _ = course!.repeatableForCredit { Text("**Repeatable for Credit:** Yes") }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .foregroundStyle(Color.supaWhite)
                    
                    
                    reviews
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(height: 2)
                        .padding(.vertical)
                        .foregroundStyle(Color.supaDark28)
                    
                    myProgressSection
                }
                .scrollIndicators(.hidden)
                
            }
            .padding()
            .disabled(showRateCoursePopup)
            
            if showRateCoursePopup {
                CourseReviewPopup(courseCode: courseCode, areaTitle: areaTitle, showPopup: $showRateCoursePopup)
            }
        }
    }
    
    var myProgressSection: some View {
        VStack {
            Text("My Progress")
                .foregroundStyle(Color.supaWhite)
                .font(.tTitle)
                .bold()

            Picker("", selection: $status) {

                Text("Available").tag("available")
                    .foregroundStyle(Color.supaWhite)
                    .font(.tLargeTitle)
                                    
                Text("Taking").tag("taking")
                    .foregroundStyle(Color.supaWhite)
                
                Text("Taken").tag("taken")
                    .foregroundStyle(Color.supaWhite)
                
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .disabled(course == nil)
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
                   
                   difficultyStars = doc["difficultyStars"] as? Double ?? 0
                   satisfactionStars = doc["satisfactionStars"] as? Double ?? 0
                   totalReviews = doc["numReviews"] as? Double ?? 0
               }
       }
   }
    
    func submitCourseReview(areaTitle: String, courseName: String, review: Review) {
        
        print("a tit: " + areaTitle)
        print("c code: " + courseCode)
        
        let db = Firestore.firestore()
        db.collection("areasOfStudy")
            .document(areaTitle)
            .collection("courses")
            .document(courseCode)
            .updateData([
                "numReviews" : FieldValue.increment(1.0),
                "totalDifficultyStars" : FieldValue.increment(review.difficultyStars),
                "totalSatisfactionStars" : FieldValue.increment(review.satisfactionStars),
                //"allReviews" : append to firestore array...
            ])
    }
    
    func ratingColorMap(_ rating: Double) -> Color {
//        guard rating < 80 else { return Color(red: 0, green: 1, blue: 0) } // green
//        guard rating < 60 else { return Color(red: 0.5, green: 1, blue: 0 )} // yellow-green
//        guard rating < 40 else { return Color(red: 1, green: 1, blue: 0 )} // yellow
//        guard rating < 20 else { return Color(red: 1, green: 0.5, blue: 0 )} // orange
//        return Color(red: 1, green: 0, blue: 0) // red
        
        guard rating < 4 else { return Color(red: 0, green: 1, blue: 0) } // green
        guard rating < 3 else { return Color(red: 0.75, green: 1, blue: 0 )} // yellow-green
        guard rating < 2 else { return Color(red: 1, green: 1, blue: 0 )} // yellow
        guard rating < 1 else { return Color(red: 1, green: 0.5, blue: 0 )} // orange
        return Color(red: 1, green: 0, blue: 0) // red
    }
}
