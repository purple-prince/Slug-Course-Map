//
//  ContentView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/10/23.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    
    enum Tab { case profile, courseBook }
    
    @State var currentTab: Tab = .profile

    
}

extension ContentView {
    var body: some View {
        ZStack {
            VStack {
                if currentTab == .profile {
                    ProfileView()
                } else {
                    CourseBookView()
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
                .onTapGesture { currentTab = .courseBook }
            
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
