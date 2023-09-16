//
//  BackButton.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 9/15/23.
//

import SwiftUI

struct BackButton: View {
    
    let action: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.appPrimary)
                    .onTapGesture {
                        action()
                    }
                
                Spacer()
            }
            
            Spacer()
        }
    }
}
