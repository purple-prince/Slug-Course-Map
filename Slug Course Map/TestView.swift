//
//  TestView.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/20/23.
//

import SwiftUI
import SwiftData

struct TestView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TestView()
}

@Model
class DataItem {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
