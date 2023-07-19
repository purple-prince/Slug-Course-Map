//
//  CourseView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/16/23.
//

import SwiftUI
import FirebaseFirestore

enum CourseStatus: String {
    case locked, available, taken, taking
}

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
    @State var status: CourseStatus = .locked
    var oldStatus: CourseStatus = .locked
    @AppStorage("takenCredits") var takenCredits = 0
    
    init(courseCode: String, areaTitle: String) {
        self.courseCode = courseCode
        self.areaTitle = areaTitle
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.appBlue)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        
        
    }
}

extension CourseView {
    var body: some View {
        ZStack {
            if let _ = course {
                courseDetails
            }
        }
        //.navigationBarTitle(Text(""), displayMode: .inline)
        .onAppear {
            getCourseDetails()
        }
        .foregroundColor(.appPrimary)
        .onChange(of: status) { _ in
            @AppStorage(courseCode) var storedStatus: CourseStatus = .available
            storedStatus = status
            
            if status == .taken {
                takenCredits += course?.credits ?? 0
            } else {
                
            }
        }
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
                    Text("**Prerequisites:** \(preReqs)")
                }
                
                if let instructor = course!.instructor {
                    Text("**Instructor:** \(instructor)")
                }
                
                if let genEdCode = course!.genEdCode {
                    Text("**Gen Ed Code:** \(genEdCode.uppercased())")
                }
                
                if let qsOffered = course!.quartersOffered {
                    Text("**Quarters Offered:** \(qsOffered)")
                }
                
                if let _ = course!.repeatableForCredit {
                    Text("**Repeatable for Credit:** Yes")
                }
                
                HStack {
                    Spacer()
                }
            }
            
            Spacer()
            
            VStack {
                Text("Status")
                    .font(.title)
                    .bold()
                
                Picker("", selection: $status) {
                    Image(systemName: "lock").tag(CourseStatus.locked)
                    
                    Text("Taken").tag(CourseStatus.taken)
                    
                    Text("Taking").tag(CourseStatus.taking)
                    
                    Text("Can Take").tag(CourseStatus.available)
                        .font(.largeTitle)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 12)
                .disabled(course == nil)
            }
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
        
        @AppStorage(courseCode) var storedStatus: CourseStatus = .available
        status = storedStatus
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView(courseCode: "yidd 99f", areaTitle: "Yiddish")
    }
}
