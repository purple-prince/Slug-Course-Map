//
//  CourseBookVM.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/26/23.
//

//MARK: plane changes

import Foundation
import FirebaseFirestore
import SwiftUI

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

struct CourseReviewPopup: View {
    
    let courseCode: String
    let areaTitle: String
    
    @State var difficultyStars: Int = 1
    @State var satisfactionStars: Int = 1
    @Binding var showPopup: Bool
    
    var difficultySection: some View {
        HStack {
            Text("Difficulty")
                .foregroundStyle(Color.supaWhite)
            
            Spacer()
            
            HStack(spacing: 1) {
                ForEach(1..<6) { num in
                    Image(systemName: difficultyStars >= num ? "star.fill" : "star")
                        .foregroundStyle(.yellow)
                        .font(.tTitle)
                        .onTapGesture {
                            difficultyStars = num
                            
                            HapticManager.manager.playHaptic(type: .soft)
                        }
                }
            }
        }
    }
    
    var satisfactionSection: some View {
        HStack {
            
            Text("Satisfaction")
                .foregroundStyle(Color.supaWhite)
            
            Spacer()
            
            HStack(spacing: 1) {
                ForEach(1..<6) { num in
                    Image(systemName: satisfactionStars >= num ? "star.fill" : "star")
                        .font(.tTitle)
                        .foregroundStyle(.yellow)
                        .onTapGesture {
                            satisfactionStars = num
                            
                            HapticManager.manager.playHaptic(type: .soft)
                        }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.supaDark28)
                .shadow(color: .black, radius: 12)
                
            
            VStack {
                Text("Write a review")
                    .font(.tTitle)
                    .foregroundStyle(Color.supaWhite)
                
                Spacer()
                Spacer()
                
                VStack {
                    Spacer()
                    difficultySection
                    
                    satisfactionSection
                    
                    Spacer()
                    
                    submitButton
                }
                
                Spacer()
            }
            .foregroundStyle(Color.appBlue)
            .padding()
            
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    Image(systemName: "xmark")
                        .font(.tTitle)
                        .onTapGesture {
                            showPopup = false
                        }
                        .padding()
                        .foregroundStyle(Color.supaWhite)
                }
                
                Spacer()
            }
        }
        .frame(height: 300)
        .padding(.horizontal)
        .padding(.horizontal)
    }
    
    var submitButton: some View {
        Button(action: {
            
            if difficultyStars > 0 && satisfactionStars > 0 {
                let review = Review(difficultyStars: Double(difficultyStars), satisfactionStars: Double(satisfactionStars))
                submitCourseReview(areaTitle: areaTitle, courseCode: courseCode, review: review)
            }
        }) {
            Text("Submit")
                .foregroundStyle(Color.supaWhite)
                .font(.tTitle2)
                .padding()
                .background(
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.supaDark28)
                            .shadow(color: .supaGreen, radius: 2)
                    }
                )
        }
    }
    
    func submitCourseReview(areaTitle: String, courseCode: String, review: Review) {
        let db = Firestore.firestore()
        db.collection("areasOfStudy")
            .document(areaTitle)
            .collection("courses")
            .document(courseCode)
            .updateData([
                "numReviews" : FieldValue.increment(1.0),
                "difficultyStars" : FieldValue.increment(review.difficultyStars),
                "satisfactionStars" : FieldValue.increment(review.satisfactionStars),
                //"allReviews" : append to firestore array...
            ])
    }
}

#Preview {
    ZStack {
        Color.supaDark.ignoresSafeArea()
        
        CourseReviewPopup(courseCode: "", areaTitle: "" , showPopup: .constant(true))
    }
}


class Review {
    let difficultyStars: Double
    let satisfactionStars: Double
    
    init(difficultyStars: Double, satisfactionStars: Double) {
        self.difficultyStars = difficultyStars
        self.satisfactionStars = satisfactionStars
    }
}
