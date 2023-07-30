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
    
    init(areaTitle: String, areaCode: String) {
        self.areaTitle = areaTitle
        self._areaCode = State(wrappedValue: areaCode)
        self._relevantCourses = Query(filter: #Predicate { $0.code.contains(areaCode) })
    }
}

struct CourseView: View {
    
    let courseCode: String
    let areaTitle: String
    @State var course: Course?
    @State var status: String = "available"
    @State var statusIsInitialized: Bool = false

//    @SwiftData.Query var selectedCourseDataArray: [CourseDataModel]
//    @Environment(\.modelContext) var context
//    @AppStorage("taken_credits") var taken_credits: Int = 0
    @AppStorage("taking_credits") var taking_credits: Int = 0

//    init(courseCode: String, areaTitle: String) {
//        self.courseCode = courseCode
//        self.areaTitle = areaTitle
//
//        self._selectedCourseDataArray = SwiftData.Query(filter: #Predicate { $0.code == courseCode } )
//
//        //self._status = State(wrappedValue: selectedCourseDataArray.first!.status)
//
//        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.appBlue)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//
//        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16)], for: .normal)
//    }
    
    var body: some View {
        Text("A")
    }
}

struct TempView: View {
    
    //@AppStorage("pooppy") var poop: Int = 0
    
    var body: some View {
        Text("Textx")
    }
}

extension AreaView {
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCourseCodes, id: \.self) { code in // i.e. YIDD 99F
                    
                    NavigationLink(destination: TempView()) {//CourseView(courseCode: code.lowercased(), areaTitle: areaTitle)) {
                        Text(code)
                            .foregroundColor(.appPrimary)
                        
                    }
                    
                    //.listRowBackground(getCompletionColor(code: code)?.0)
                    //.opacity(getCompletionColor(code: code)?.1 ?? 1.0)
                }
            }
            .navigationTitle(areaTitle)
        }
        .onAppear {
            getAreaDetails()// this is a comment
        }
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
                //areaCode = (doc["code"] as? String ?? "Error")
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
