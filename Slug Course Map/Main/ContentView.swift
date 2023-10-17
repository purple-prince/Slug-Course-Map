//
//  ContentView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/10/23.
//

import SwiftUI
import FirebaseFirestore
import SwiftData
// this is a text change
struct ContentView: View {
    
    enum Tab { case profile, courseBook, map, options, dining }
    
    @State var currentTab: Tab = .profile
    
    @State var courseBookAreaData: [String : String] = [ : ]
    
    @State var appInitialized: Bool = false
}

extension ContentView {
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                if currentTab == .profile {
                    ProfileView()
                } else if currentTab == .map {
                    MapView()
                } else if currentTab == .courseBook {
                    CourseBookView(allAreasAndCodes: $courseBookAreaData)
                } else if currentTab == .options {
                    OptionsView()
                } else {
                    DiningView()
                }
                
                tabs
            }
            .disabled(!appInitialized)
            
            if !appInitialized {
                SquiggleAnimationView(showView: $appInitialized)
            }
        }
    }
}

extension ContentView {
    var tabs: some View {
        HStack {
            
            
            Image(systemName: currentTab == .profile ? "person.fill" : "person")
                .font(.title)
                .onTapGesture { currentTab = .profile }
                .foregroundStyle(currentTab == .profile ? Color.supaGreen : Color.supaGreenSecondary)
                .brightness(currentTab == .profile ? 0.0 : 0.2)
            
            Spacer()
            
            Image(systemName: currentTab == .courseBook ? "list.bullet.clipboard.fill" : "list.bullet.clipboard")
                .font(.title)
                .brightness(currentTab == .courseBook ? 0.0 : 0.2)
                .foregroundStyle(currentTab == .courseBook ? Color.supaGreen : Color.supaGreenSecondary)
                .onTapGesture {
                    currentTab = .courseBook
//                    if !courseBookAreasCached {
//                        courseBookAreasCached = true
//                    }
                }
            
            Spacer()
            
            Image(systemName: currentTab == .map ? "map.fill" : "map")
                .font(.title)
                .brightness(currentTab == .map ? 0.0 : 0.2)
                .onTapGesture { currentTab = .map }
                .foregroundStyle(currentTab == .map ? Color.supaGreen : Color.supaGreenSecondary)
            
            
            Spacer()
            
            Image(systemName: "fork.knife")
                .brightness(currentTab == .dining ? 0.0 : 0.2)
                .foregroundStyle(currentTab == .dining ? Color.supaGreen : Color.supaGreenSecondary)
                .font(.title)
                .onTapGesture { currentTab = .dining }
            
            Spacer()
            
            Image(systemName: "slider.horizontal.3")
                .brightness(currentTab == .options ? 0.0 : 0.2)
                .foregroundStyle(currentTab == .options ? Color.supaGreen : Color.supaGreenSecondary)
                .font(.title)
                .onTapGesture { currentTab = .options }
            
        }
        .foregroundColor(.supaGreen)
        .padding(.top, 8)
        .padding(.horizontal)
        .padding(.horizontal)
        .background(Color.supaDarkSecondary)
    }
}

#Preview {
    ContentView()
}
