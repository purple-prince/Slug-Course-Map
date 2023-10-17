//
//  AreaView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/16/23.
//

import SwiftUI
import SwiftData
import FirebaseFirestore


struct AreaView: View {
    
    let areaTitle: String
    @State var allCourseCodes: [String] = []
    @State var areaCode: String
    
    @State var rowAppearances: [String : (Color, Double)] = [ : ]

    @Environment(\.modelContext) var context
//    @SwiftData.Query var relevantCourses: [CourseDataModel]
    @Query var relevantCourses: [CourseDataModel] //MARK: here
    
    // Detail Screen Vars
    
    @State var showCourseView: Bool = false
    @State var courseSelectedCode: String = ""

//    // End Detail Screen Vars
        
    init(areaTitle: String, areaCode: String) {
        self.areaTitle = areaTitle
        self._areaCode = State(wrappedValue: areaCode)
        self._relevantCourses = Query(filter: #Predicate { $0.code.contains(areaCode) })

    }
}

extension AreaView {
    
    func getRowAppearances() -> [String : (Color, Double)] {
        
        var courseCodes: [String] = []
        var courseStatuses: [String] = []
        
        for course in relevantCourses {
            courseCodes.append(course.code)
            courseStatuses.append(course.status)
        }
        
        let courseAppearances: [(Color, Double)] = courseStatuses.map {
            switch $0 {
                case "taken": return (Color(red: 0.6, green: 0.95, blue: 0.6), 0.7)
                case "taking": return (Color(red: 1, green: 0.9, blue: 0), 0.85)
                default: return (Color.white, 1.0)
            }
        }
        
        var finalAppearances: [String : (Color, Double)] = [ : ]
        
        for i in 0..<courseCodes.count {
            finalAppearances[courseCodes[i]] = courseAppearances[i]
        }
        
        return finalAppearances
        
        
    }
    
    func onClick(code: String) {
        
        if relevantCourses.filter({ $0.code == code }).isEmpty {
            context.insert(CourseDataModel(code: code))
            do { try context.save(); } catch { print(error.localizedDescription )}
        }
                
        courseSelectedCode = code
        
        showCourseView = true
                
    }
    
    var body: some View {
        
        ZStack {
            if showCourseView {
                CourseView(courseCode: courseSelectedCode.lowercased(), areaTitle: areaTitle, showCourseView: $showCourseView)
            } else {
                
                VStack {
                    List {
                        ForEach(allCourseCodes, id: \.self) { code in // i.e. YIDD 99F
                            HStack {
                                Text(code)
                                    .foregroundColor(.supaWhite)
                                
                                Color.supaDark28.opacity(0.01)
                                
                            }
                            .listRowBackground(Color.supaDark28)
                            .onTapGesture {
                                onClick(code: code.lowercased())
                            }
                            .listRowBackground(rowAppearances.keys.contains(code.lowercased()) ? rowAppearances[code.lowercased()]!.0.opacity(rowAppearances[code.lowercased()]!.1) : Color.white)
                            .opacity(rowAppearances.keys.contains(code.lowercased()) ? rowAppearances[code.lowercased()]!.1 : 1.0)
                        }
                    }
                    .background(Color.supaDark)
                    .scrollContentBackground(.hidden)
                    .navigationTitle("SKFH")
                    
                }
                .onAppear {
                    getAreaDetails()
                    self.rowAppearances = getRowAppearances()
                }
            }
        }
    }
}

extension AreaView {
    
}

extension AreaView {
    func getAreaDetails() {
        let db = Firestore.firestore()
        db.collection("areasOfStudy").document(areaTitle).getDocument { snapshot, error in
            if let error = error { print(error.localizedDescription); return; }
            if let doc = snapshot {
                areaCode = (doc["code"] as? String ?? "Error")
                allCourseCodes = (doc["classCodes"] as? [String] ?? ["Error :("]).map { "\(areaCode.uppercased()) \($0)" }
            }
        }
    }
}
