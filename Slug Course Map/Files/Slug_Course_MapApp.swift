//
//  Slug_Course_MapApp.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/10/23.
//

import SwiftUI
import FirebaseCore
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct Slug_Course_MapApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.appPrimary)]
    }
    
    var body: some Scene {
        WindowGroup {
//            view1()
            ContentView()
                .preferredColorScheme(.light)
//            hDegreeProgressView()
        }
        .modelContainer(for: CourseDataModel.self)
    }
}





struct view2: View {
    
    init(h: String) {
        print(h)
    }
    
    var body: some View {
        ZStack {}
    }
}

struct view1: View {
    
    var body: some View {
        List {
            ForEach(0..<10) { n in
                NavigationLink(destination: view2(h: n.description)) {
                    Text("s")
                }
            }
        }
    }
    
//    @AppStorage("array") var array: [String : String] = [:]
//    
//    var body: some View {
//        
//        Picker("", selection: $array["item1"]) {
//            Text("value 1").tag(Optional("value1"))
//            Text("value 2").tag(Optional("value2"))
//            Text("value 3").tag(Optional("value3"))
//        }
//        .pickerStyle(SegmentedPickerStyle())
//    }
}
