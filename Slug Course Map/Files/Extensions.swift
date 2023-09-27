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

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
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
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8) // nsdata to String
        else {
            return "{}"
        }
        return result
    }

}

extension Font {
    
    // custom font replacements mathing built-in sizes, with dynamic type scaling support
    
    static var tTitle: Font { Font.custom("Titillium-Regular", size: 28, relativeTo: .title) }
    static var tTitle2: Font { Font.custom("Titillium-Regular", size: 22, relativeTo: .title2) }
    static var tTitle3: Font { Font.custom("Titillium-Regular", size: 20, relativeTo: .title3) }
    static var tBody: Font { Font.custom("Titillium-Regular", size: 17, relativeTo: .body) }
    static var tLargeTitle: Font { Font.custom("Titillium-Regular", size: 34, relativeTo: .largeTitle) }
    static var tCallout: Font { Font.custom("Titillium-Regular", size: 16, relativeTo: .callout) }
    
    static var tTitleBold: Font { Font.custom("Titillium-Bold", size: 28, relativeTo: .title) }
    static var tLargeTitleBold: Font { Font.custom("Titillium-Bold", size: 34, relativeTo: .largeTitle) }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
