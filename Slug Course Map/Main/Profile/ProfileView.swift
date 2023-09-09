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
    @AppStorage("selected_major") var selected_major: String = "Select Major"
    
    @State var showDegreeProgressView: Bool = false
    @State var showDegreeView = false
    
        
    var body: some View {//180 req cred
        ZStack {
            
            if showDegreeView {
                DegreeView(showDegreeView: $showDegreeView)
            } else {
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
                                    
                    degreeProgressButton
                    
                    Spacer()
                }
                .padding()
            }
        }
        .foregroundColor(.appBlue)
    }
}

extension ProfileView {
    var degreeProgressButton: some View {
        VStack {
            HStack {
                Text("Degree Progress")
                    .font(.title3)

                Spacer()
                
                Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
            }
            .padding(.horizontal)
            .foregroundColor(.appPrimary)
        }
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
        .shadow(color: Color(red: 0.7, green: 0.7, blue: 0.7), radius: 10)
        .onTapGesture {
            //showDegreeProgressView = true
            showDegreeView = true
        }
    }
}

#Preview {
    ProfileView()
}
