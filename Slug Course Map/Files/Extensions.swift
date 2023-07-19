//
//  Extensions.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/18/23.
//

import Foundation
import SwiftUI


extension Color {
    static let appYellow = Color(red: 1, green: 214/255, blue: 10/255)
    static let appBlue = Color(red: 0, green: 53/255, blue: 102/255)
    
    static var appPrimary: Color {
        //if UITraitCollection.current.userInterfaceStyle == .dark { return .appYellow }
        return .appBlue
    }
}
