//
//  ContentView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/10/23.
//

import SwiftUI
import FirebaseFirestore
import SwiftData

struct ContentView: View {
    
    enum Tab { case profile, courseBook }
    
    @State var currentTab: Tab = .profile
    @SwiftData.Query var th: [CourseDataModel]
    @Environment(\.modelContext) var context
    
    @State var courseBookAreaData: [String : String] = [ : ]
    
}

extension ContentView {
    var body: some View {
        VStack {
            VStack {
                if currentTab == .profile {
                    ProfileView()
                } else {
                    CourseBookView(allAreasAndCodes: $courseBookAreaData)
                }
                Spacer()
                tabs
            }
        }
    }
}

extension ContentView {
    var tabs: some View {
        HStack {
            
            Spacer()
            
            Image(systemName: currentTab == .profile ? "person.fill" : "person")
                .font(.title)
                .onTapGesture { currentTab = .profile }
            
            Spacer()
            
            Image(systemName: currentTab == .courseBook ? "list.bullet.clipboard.fill" : "list.bullet.clipboard")
                .font(.title)
                .onTapGesture {
                    currentTab = .courseBook
//                    if !courseBookAreasCached {
//                        courseBookAreasCached = true
//                    }
                }
            
            Spacer()
        }
        .foregroundColor(.appYellow)
        .padding(.top, 8)
        .padding(.horizontal)
        .background(Color.appPrimary)
    }
}

#Preview {
    ContentView()
}
