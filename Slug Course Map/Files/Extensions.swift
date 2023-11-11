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
    
    
    static let supaYellow = Color(red: 245/255, green: 158/255, blue: 12/255)
    static let supaYellowSecondary = Color(red: 51/255, green: 40/255, blue: 31/255) //
    
    static let supaDark = Color(red: 24/255, green: 24/255, blue: 24/255)
    static let supaDark28 = Color(red: 28/255, green: 28/255, blue: 28/255)
    static let supaDarkSecondary = Color(red: 31/255, green: 31/255, blue: 31/255) //
    
    static let supaBlue = Color(red: 60/255, green: 129/255, blue: 246/255)
    static let supaBlueSecondary = Color(red: 32/255, green: 38/255, blue: 52/255) //
    
    static let supaGreen = Color(red: 36/255, green: 180/255, blue: 126/255)
    static let supaGreenSecondary = Color(red: 33/255, green: 46/255, blue: 41/255)
    
    static let supaRed = Color(red: 239/255, green: 68/255, blue: 68/255)
    static let supaRedSecondary = Color(red: 51/255, green: 33/255, blue: 32/255)
    
//    static let supaWhite = Color(red: 249/255, green: 247/255, blue: 240/255)
//    static let supaWhiteSecondary = Color(red: 239/255, green: 68/255, blue: 68/255)
//    
//    static let supaWhiteEggshell = Color(red: 240/255, green: 234/255, blue: 214/255)
//    static let supaWhitePearl = Color(red: 234/255, green: 224/255, blue: 200/255)
    
    static let supaWhite = Color(red: 212/255, green: 212/255, blue: 212/255)
    
    
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
    static var tTitle2Bold: Font { Font.custom("Titillium-Bold", size: 22, relativeTo: .title2) }
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


extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
