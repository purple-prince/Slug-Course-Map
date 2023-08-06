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
//    @State var isNavLinkActive: Bool = false
//    
//    
    @Environment(\.modelContext) var context
    @SwiftData.Query var relevantCourses: [CourseDataModel]
    
    // Detail Screen Vars
    
    @State var showCourseView: Bool = false
    @State var courseSelectedCode: String = ""
//    
//    // End Detail Screen Vars
//    
//    @AppStorage("randop") var randop = false
    
    @AppStorage("courses_status") var courses_status: [String: String] = [:]
    
    init(areaTitle: String, areaCode: String) {
        self.areaTitle = areaTitle
        self._areaCode = State(wrappedValue: areaCode)
        self._relevantCourses = Query(filter: #Predicate { $0.code.contains(areaCode) })
//        print("Area code: " + areaCode)
//        print("isEmpty:" + areaCode.isEmpty.description)
    }
}

////struct ContentView: View {
////    var body: some View {
////        List {
////            ForEach(...) {
////                NavigationLink("", destination: SubView(...))
////            }
////        }
////    }
////}
////
////struct SubView: View {
////    
////    @Query var data: [DataModel]
////    
////    init(id: String) {
////        self.data = Query(filter: #Predicate { $0.id == id })
////    }
////    
////    var body: some View {
////        List {
////            ForEach(...) {
////                NavigationLink("", destination: SubView(...))
////            }
////        }
////    }
////}
//


extension AreaView {
    
    func onClick(code: String) {
        
        if relevantCourses.filter({ $0.code == code }).isEmpty {
            context.insert(CourseDataModel(code: code))
            do { try context.save(); } catch { print(error.localizedDescription )}
//            courses_status[code] = "available"
//            print(relevantCourses.count.description)
//            print("ADDED")
        }
                
        courseSelectedCode = code
        
        showCourseView = true
                
    }
    
    var body: some View {
        
        ZStack {
            if showCourseView {
                CourseView(courseCode: courseSelectedCode.lowercased(), areaTitle: areaTitle)
            } else {
                
                VStack {
                    List {
                        ForEach(allCourseCodes, id: \.self) { code in // i.e. YIDD 99F
                            Text(code)
                                .foregroundColor(.appPrimary)
                                .background(getCourseColor(code: code).0)
                                .onTapGesture {
                                    onClick(code: code.lowercased())
                                }
                        }
                    }
                }
                .onAppear {
                    getAreaDetails()
                }
            }
        
        }
    }

        
////        NavigationStack {
////            List {
////                ForEach(allCourseCodes, id: \.self) { code in // i.e. YIDD 99F
////                    
////                    NavigationLink(destination: CourseView(courseCode: code.lowercased(), areaTitle: areaTitle)) {
////                        Text(code)
////                            .foregroundColor(.appPrimary)
////                        
////                    }
////                    
////                    //.listRowBackground(getCompletionColor(code: code)?.0)
////                    //.opacity(getCompletionColor(code: code)?.1 ?? 1.0)
////                }
////            }
////            .navigationTitle(areaTitle)
////        }
//    }
}

extension AreaView {
    
}

extension AreaView {
    
    func getCourseColor(code: String) -> (Color, Double) {
        switch courses_status[code] {
            case "taken": return (.green, 0.5)
            case "taking": return (.yellow, 1.0)
            default: return (Color.clear, 0)
        }
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
//    
////    func saveCourse(code: String) {
////        context.insert(CourseDataModel(code: code))
////        do { try context.save() } catch { print(error.localizedDescription) }
////        print("ayy iss a success")
////        // i.e. yidd 93f
////    }
}

//#Preview {
//    AreaView(areaTitle: "Yiddish", areaCode: "yidd")
//        //.modelContext(CourseDataModel.self)
//}
