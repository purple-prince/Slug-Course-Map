//
//  ProfileView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/18/23.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    
    @AppStorage("taken_credits") var taken_credits: Int = 0
    @AppStorage("taking_credits") var taking_credits: Int = 0
        
    var body: some View {//180 req cred
        ZStack {
            VStack {
                Text("Coursework")
                    .font(Font.system(size: 48))
                    .bold()
                
                VStack(alignment: .leading) {
                    Text("**Completed Credits:** \(taken_credits) / 180")
                        .font(.title2)
                    
                    Text("**Current Term Credits:** \(taking_credits)")
                        .font(.title2)
                        
                    HStack { Spacer() }
                }
                .padding(.top, 48)
                
                Spacer()
            }
            .padding()
        }
        .foregroundColor(.appBlue)
    }
}

#Preview {
    ProfileView()
}
