//
//  DegreeProgressView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 8/22/23.
//

import SwiftUI
import FirebaseFirestore
import SwiftData
import Combine

//    @AppStorage("completed_courses") var completed_courses: [String] = []
//    @State var progress: Double = 0.0
//
//    init(title: String, network: Bool = true) {
//        self.title = title
//
//        if network {
//            determineDegreeCompletion(courseName: title.lowercased())
//        } else {
//            progress = 0.5
//        }
//    }
//
//    func determineDegreeCompletion(courseName: String) {
//
//        let db = Firestore.firestore()
//        db.collection("degree")
//            .document("undergradDegreeInfo")
//            .collection("undergradMajors")
//            .document(courseName)
//            .getDocument { snapshot, error in
//                if let error = error { print(error.localizedDescription); return }
//                if let doc = snapshot {
//                    let encodedReqs = doc["courseReqs"] as? [String] ?? ["Error"]
//                    var reqsCompleted: Double = 0
//
//                    for req in encodedReqs {
//                        if requirementPassed(req: req) {
//                            reqsCompleted += 1
//                        }
//                    }
//
//                    print(self.progress.description)
//                    self.progress = 0.99
//                    print(self.progress.description)
//
//                }
//            }
//
//
//
//        func requirementPassed(req: String) -> Bool {
//
//            if req.hasPrefix("either") {
//
//                // either stat 7 and stat 7l or stat 17 and stat 17l
//
//                let joinedReqs = req.deletingPrefix("either ")
//                // stat 7 and stat 7l or stat 17 and stat 17l
//
//                let strReqSets = joinedReqs.components(separatedBy: " or ")
//                // ["stat 7 and stat 7l", "stat 17 and stat 17l"]
//
//                let reqSets = strReqSets.map { reqs in
//                    return reqs.components(separatedBy: " and ")
//                }
//                // [["stat 7", "stat 7l"], ["stat 17", ["stat 17l"]]
//
//
//                for reqSet in reqSets {
//                    if !(reqSet.filter({ course in
//                        return requirementPassed(req: course)
//                    }).isEmpty) {
//                        return true
//                    }
//                }
//
//                return false
//
//            } else if req.contains(" or ") {
//
//                let courses = Set(req.components(separatedBy: " or "))
//                let satisfiedCourses = courses.intersection(completed_courses)
//                return !satisfiedCourses.isEmpty
//
//            } else {
//                return completed_courses.contains(req)
//            }
//        }
//    }

class Degree: ObservableObject {
    
    @Published var title: String
    @Published var progress: Double
    @AppStorage("completed_courses") var completed_courses: [String] = []
    
    init(title: String, network: Bool = true) {
        self.title = title
        self.progress = 0.0
        
        
        if network {
            determineDegreeCompletion(courseName: title.lowercased())
        } else {
            self.progress = 0.5
        }
    }
    
    func determineDegreeCompletion(courseName: String) {

        let db = Firestore.firestore()
        db.collection("degree")
            .document("undergradDegreeInfo")
            .collection("undergradMajors")
            .document(courseName)
            .getDocument { snapshot, error in
                if let error = error { print(error.localizedDescription); return }
                if let doc = snapshot {
                    let encodedReqs = doc["courseReqs"] as? [String] ?? ["Error"]
                    var reqsCompleted: Double = 0

                    for req in encodedReqs {
                        if requirementPassed(req: req) {
                            reqsCompleted += 1
                        }
                    }

                    self.progress = reqsCompleted / Double(encodedReqs.count)

                }
            }
    
        func requirementPassed(req: String) -> Bool {
            
            var spaceUsed = false
            var currentClass = ""
            var wordStarted = false
            
            var swiftReqs = req
                .replacingOccurrences(of: "or", with: "|")
                .replacingOccurrences(of: "and", with: "&")
            
            // begin checking for number beginning
            // number of classes required if the requirement is "x classes out of _, _, _, ..."
            var classesFromSetRequired: Int = 0
                
            if req.first!.isNumber {
                var strReqNum = ""
                var checkingForNums: Bool = true
                var numberEndIndex: Int = 0
                
                for (index, char) in req.enumerated() {
                    guard checkingForNums else { break }
                    
                    if char.isNumber {
                        strReqNum += String(char)
                    } else {
                        checkingForNums = false
                        
                        // since the req in db will look like "3: class 1, class 2...", this accounts for colon and space
                        numberEndIndex = index + 2
                    }
                }
                classesFromSetRequired = Int(strReqNum)!
                swiftReqs.removeFirst(numberEndIndex)
                
                // i.e. swiftreqs is (econ 10a)(math 19b | math 20b)(math 22 | math 23a | am 30)
                        
                for char in swiftReqs {
                    if char.isLetter || char.isNumber || (char == " ") {
                        if !wordStarted {
                            if char != " " {
                                wordStarted = true
                                currentClass += String(char)
                            }
                            
                        } else {
                            if char == " " {
                                if spaceUsed {
                                    // word over, replace w bool
                                    if let range = swiftReqs.range(of: currentClass) {
                                        swiftReqs = swiftReqs.replacingCharacters(in: range, with: completed_courses.contains(currentClass) ? "t" : "f")
                                        wordStarted = false
                                        currentClass = ""
                                    } else { print("ERROR IN REGEX ALGO!") }
                                } else { currentClass += " " }
                                
                                spaceUsed.toggle()
                                
                            } else { currentClass += String(char) }
                        }
                    } else {
                        if wordStarted {
                            // replace w bool
                            if let range = swiftReqs.range(of: currentClass) {
                                swiftReqs = swiftReqs.replacingCharacters(in: range, with: completed_courses.contains(currentClass) ? "t" : "f")
                                wordStarted = false
                                currentClass = ""
                                spaceUsed = false
                            } else { print("ERROR IN REGEX ALGO!") }
                        }
                    }
                }
                
                swiftReqs = swiftReqs.replacingOccurrences(of: " ", with: "")
                
                return parse(swiftReqs, countMode: true)
                
            }
            
            // end checking for number beginning
               
            for char in swiftReqs {
                if char.isLetter || char.isNumber || (char == " ") {
                    if !wordStarted {
                        if char != " " {
                            wordStarted = true
                            currentClass += String(char)
                        }
                        
                    } else {
                        if char == " " {
                            if spaceUsed {
                                // word over, replace w bool
                                if let range = swiftReqs.range(of: currentClass) {
                                    swiftReqs = swiftReqs.replacingCharacters(in: range, with: completed_courses.contains(currentClass) ? "t" : "f")
                                    wordStarted = false
                                    currentClass = ""
                                } else { print("ERROR IN REGEX ALGO!") }
                            } else { currentClass += " " }
                            
                            spaceUsed.toggle()
                            
                        } else { currentClass += String(char) }
                    }
                } else {
                    if wordStarted {
                        // replace w bool
                        if let range = swiftReqs.range(of: currentClass) {
                            swiftReqs = swiftReqs.replacingCharacters(in: range, with: completed_courses.contains(currentClass) ? "t" : "f")
                            wordStarted = false
                            currentClass = ""
                            spaceUsed = false
                        } else { print("ERROR IN REGEX ALGO!") }
                    }
                }
            }
                
            if !currentClass.isEmpty {
                if let range = swiftReqs.range(of: currentClass) {
                    swiftReqs = swiftReqs.replacingCharacters(in: range, with: completed_courses.contains(currentClass) ? "t" : "f")
                    wordStarted = false
                    currentClass = ""
                } else { print("ERROR IN REGEX ALGO!") }
            }
                
            return parse(swiftReqs.replacingOccurrences(of: " ", with: ""))
            
            
            // valid letters: letter, number, space, or, and, parenthesis
            func parse(_ expr: String, countMode: Bool = false) -> Bool {
                
                let exp = expr
                var currentExp = ""
                var openParCount = 0
                var allComponents: [String] = []
                
                
                for char in exp {
                         
                    if exp.contains(")") || exp.contains("(") {
                        if char == "(" {
                            openParCount += 1
                            if openParCount > 1 { currentExp += "(" }
                            continue
                        } else if char == ")" {
                            openParCount -= 1
                            
                            if openParCount > 0 { currentExp += ")" }
                        } else { currentExp += String(char) }
                    } else { currentExp = String(char) }
                    
                    if openParCount == 0 {
                        allComponents.append(currentExp)
                        currentExp = ""
                    }
                }
                        
                for i in 0..<allComponents.count {
                    
                    let subExpression = allComponents[i]
                    
                    if subExpression.first!.isLetter {
                        allComponents[i] = String(solveArray(arr: subExpression.map({String($0)})).description.first!)
                    }
                }
                
                if countMode { return allComponents.filter({ $0 == "t" }).count >= classesFromSetRequired }
                
                return solveArray(arr: allComponents)
                
                // i.e.  ["f", "|", "f", "|", "t"]
                func solveArray(arr: [String]) -> Bool {
                    
                    var array = arr
                                
                    while array.count > 1 {
                        
                        let (bool1, op, bool2) = (array[0] == "t", array[1], array[2] == "t")
                            
                        array.removeFirst(2)
                            
                        if op == "|" { array[0] = String((bool1 || bool2).description.first!) }
                        else if op == "&" { array[0] = String((bool1 && bool2).description.first!) }
                    }
                    
                    return array.first! == "t"
                }
            }
        }
    }

}

class AllDegrees: ObservableObject {

    @Published var allDegrees: [Degree] = []
    var objectStorage: [AnyCancellable] = []
    
    init() {
       getAllDegreeNames()
    }
    
    func getAllDegreeNames() {
        let db = Firestore.firestore()
        
        db.collection("degree").document("undergradDegreeInfo").getDocument { snapshot, error in
            if let error = error { print(error.localizedDescription); return }
            if let doc = snapshot {
                
//                allDegrees.append(contentsOf: [Degree(title: "UC Requirements", network: false), Degree(title: "Gen Ed Requirements", network: false)])
                
                for i in doc["majorsOffered"] as? [String] ?? ["Error"] {
                    
                    let deg = Degree(title: i)
                    deg.objectWillChange.sink {
                        self.objectWillChange.send()
                    }
                    .store(in: &self.objectStorage)
                    
                    self.allDegrees.append(deg)
                }
            }
        }
    }    
}

struct DegreeProgressView: View {
    @Binding var showDegreeProgressView: Bool
    
    //@Observed var allDegrees: [Degree] = []
    @StateObject var allDegrees: AllDegrees = AllDegrees()
    
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

                
                if !allDegrees.allDegrees.isEmpty {
                    ScrollView {
                        VStack {
                            ForEach(allDegrees.allDegrees, id: \.title) { degree in
                                DegreeItemCard(degree: degree)
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
    }
}

struct DegreeItemCard: View {
    
    @State var degree: Degree
    @AppStorage("completed_courses") var completed_courses: [String] = []
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(degree.title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .onTapGesture {
                        print(completed_courses.description)
                    }
                
                HStack {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .stroke(Color.appBlue, lineWidth: 2)

                        Rectangle()
                            .fill(Color.appBlue)
                            .frame(width: degree.progress * 250)
//                            .frame(width: 100)
                    }
                    .frame(width: 250, height: 16)
                    .clipShape(Capsule())
                    
                    Text(String(format: "%.0f", degree.progress * 100) + " %")
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

#Preview {
    DegreeProgressView(showDegreeProgressView: .constant(false))
}


