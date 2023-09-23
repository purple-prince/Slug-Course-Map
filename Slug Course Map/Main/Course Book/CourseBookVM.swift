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
    
    @State var difficultyStars: Int = 0
    @State var satisfactionStars: Int = 0
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.white)
                .blur(radius: 12)
            
            VStack {
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
}


class Review {
    let difficultyStars: Double
    let satisfactionStars: Double
    
    init(difficultyStars: Double, satisfactionStars: Double) {
        self.difficultyStars = difficultyStars
        self.satisfactionStars = satisfactionStars
    }
}
