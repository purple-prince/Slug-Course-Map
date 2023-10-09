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
                
                ZStack(alignment: .top) {
                    
                    Color.supaDark.ignoresSafeArea()
                    
                    VStack {
                        Text("Coursework")
                            .font(.custom("Titillium-Bold", size: 48))
                            .foregroundStyle(Color.supaWhite)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                HStack {
                                    Text("Completed Credits:")
                                    Spacer()
                                    Text("\(taken_credits) / 180")
                                        .foregroundStyle(Color.supaGreen)
                                }
                                
                                HStack {
                                    Text("Current Term Credits:")
                                    Spacer()
                                    Text("\(taking_credits)")
                                        .foregroundStyle(Color.supaGreen)
                                }
                            }
                            .font(.tTitle3)
                            .foregroundStyle(Color.supaWhite)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 48)
                                                                
                        degreeProgressButton
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .foregroundStyle(Color.supaDark28)
    }
}

extension ProfileView {
    var degreeProgressButton: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 1)
                )
                            
            HStack {
                Text("Degrees")
                    .font(.tTitle3)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.custom("Titillium-SemiBold", size: 16))
                
            }
            .padding(.horizontal)
            .padding(.vertical)
            .foregroundStyle(Color.supaWhite)
        }
        .fixedSize(horizontal: false, vertical: true)
        .onTapGesture {
            //showDegreeProgressView = true
            showDegreeView = true
        }
    }
}

#Preview {
    ProfileView()
}
