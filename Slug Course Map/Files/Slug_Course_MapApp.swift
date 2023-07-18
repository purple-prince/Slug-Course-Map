//
//  Slug_Course_MapApp.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/10/23.
//

import SwiftUI
import FirebaseCore

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
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.appBlue)]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
