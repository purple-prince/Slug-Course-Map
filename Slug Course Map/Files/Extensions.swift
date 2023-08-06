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

extension Dictionary: RawRepresentable where Key == String, Value == String {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),  // convert from String to Data
            let result = try? JSONDecoder().decode([String:String].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),   // data is  Data type
              let result = String(data: data, encoding: .utf8) // coerce NSData to String
        else {
            return "{}"  // empty Dictionary resprenseted as String
        }
        return result
    }

}
