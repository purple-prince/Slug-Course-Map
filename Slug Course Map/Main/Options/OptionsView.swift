//
//  OptionsView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 9/27/23.
//

import SwiftUI

struct OptionsView: View {
    
    enum Option { case settings, about, contact }
    
    @State var optionToShow: Option?
    
    var body: some View {
        ZStack {
            
            Color.supaDark.ignoresSafeArea()
            
            VStack {
                
                Text("Options")
                    .font(.tLargeTitle)
                
                Capsule()
                    .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .frame(height: 1)
                
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Settings")
                            
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .onTapGesture {
                        optionToShow = .settings
                    }
                    
                    
                    Capsule()
                        .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .frame(height: 1)
                    
                    HStack {
                        Text("About")
                           
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .onTapGesture {
                        optionToShow = .about
                    }
                    
                    Capsule()
                        .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .frame(height: 1)
                    
                    HStack {
                        Text("Contact")
                            
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .onTapGesture {
                        optionToShow = .contact
                    }
                }
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer()
            }
            .foregroundColor(.supaWhite)
        }
    }
}

#Preview {
    OptionsView()
}
