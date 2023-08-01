//
//  AreaView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/16/23.
//

import SwiftUI
import FirebaseFirestore
import SwiftData

struct AreaView: View {
    
    let areaTitle: String
    @State var allCourseCodes: [String] = []
    @State var areaCode: String
    @State var isNavLinkActive: Bool = false
    
    
    @Environment(\.modelContext) var context
    @SwiftData.Query var relevantCourses: [CourseDataModel]
    
    // Detail Screen Vars
    
    @State var showCourseView: Bool = false
    @State var courseSelectedCode: String = ""
    
    // End Detail Screen Vars
    
    init(areaTitle: String, areaCode: String) {
        self.areaTitle = areaTitle
        self._areaCode = State(wrappedValue: areaCode)
        self._relevantCourses = Query(filter: #Predicate { $0.code.contains(areaCode) })
    }
}

extension AreaView {
    
    func onClick(code: String) {

        context.insert(CourseDataModel(code: code.lowercased()))
        do { try context.save(); print("SAVED") } catch { print(error.localizedDescription )}
        
        
        courseSelectedCode = code
        
        showCourseView = true
                
    }
    
    var body: some View {
        
        ZStack {
            if showCourseView {
                CourseView(courseCode: courseSelectedCode.lowercased(), areaTitle: areaTitle)
            } else {
                List {
                    ForEach(allCourseCodes, id: \.self) { code in // i.e. YIDD 99F
                        Text(code)
                            .foregroundColor(.appPrimary)
                            .onTapGesture {
                                onClick(code: code.lowercased())
                            }
                    }
                }
                
            }
        }
        .onAppear {
            getAreaDetails()
        }
        
//        NavigationStack {
//            List {
//                ForEach(allCourseCodes, id: \.self) { code in // i.e. YIDD 99F
//                    
//                    NavigationLink(destination: CourseView(courseCode: code.lowercased(), areaTitle: areaTitle)) {
//                        Text(code)
//                            .foregroundColor(.appPrimary)
//                        
//                    }
//                    
//                    //.listRowBackground(getCompletionColor(code: code)?.0)
//                    //.opacity(getCompletionColor(code: code)?.1 ?? 1.0)
//                }
//            }
//            .navigationTitle(areaTitle)
//        }
    }
}

extension AreaView {
    
}

extension AreaView {
    
    func getCompletionColor(code: String) -> (Color, Double)? {
        
        let courses = relevantCourses.filter({ return $0.code == code })
        
        if !(courses.isEmpty) {
            switch courses.first!.status {
                case "taken": return (.green, 0.5)
                case "taking": return (.yellow, 1.0)
                default: return nil
            }
        }
        
        return nil
    }
    
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
    
    func saveCourse(code: String) {
        context.insert(CourseDataModel(code: code))
        do { try context.save() } catch { print(error.localizedDescription) }
        print("ayy iss a success")
        // i.e. yidd 93f
    }
}

#Preview {
    AreaView(areaTitle: "Yiddish", areaCode: "yidd")
        //.modelContext(CourseDataModel.self)
}
