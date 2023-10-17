//
//  OptionsView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 9/27/23.
//

import SwiftUI

struct OptionsView: View {
    var body: some View {
        ZStack {
            
            Color.supaDark.ignoresSafeArea()
            
            VStack {
                Text("Options")
                
                VStack {
                    Text("Settings")
                    Text("About")
                    Text("Contact")
                }
            }
            .foregroundColor(.supaWhite)
        }
    }
}

#Preview {
    OptionsView()
}
