//
//  ProfileView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/18/23.
//

import SwiftUI

struct ProfileView: View {
    
    @AppStorage("takenCredtis") var takenCredits: Int = 58
    
    var body: some View {//180 req cred
        ZStack {
            VStack {
                Text("Coursework")
                    .font(Font.system(size: 48))
                    .bold()
                
                VStack(alignment: .leading) {
                    Text("**Credits:** \(takenCredits) / 180")
                        .font(.title2)
                    
                    Text("**Current Term Credits:** \(0)")
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
