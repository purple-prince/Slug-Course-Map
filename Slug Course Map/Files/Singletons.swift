//
//  Singletons.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 8/6/23.
//

import Foundation
import UIKit

class HapticManager {
    enum HapticType { case light, medium, heavy, rigid, soft, success, warning, error }
    
    static let manager = HapticManager()
    
    func playHaptic(type: HapticType) {
        
        switch type {
            case .light:
                let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
                generator.impactOccurred()
            case .medium:
                let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.medium)
                generator.impactOccurred()
            case .heavy:
                let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
                generator.impactOccurred()
            case .rigid:
                let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.rigid)
                generator.impactOccurred()
            case .soft:
                let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.soft)
                generator.impactOccurred()
            case .success:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            case .warning:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            case .error:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
        }
    }
}


/*
 class HapticManager {
         
     enum HapticType { case light, medium, heavy, rigid, soft, success, warning, error }
     
     static let manager = HapticManager()
     
     func playHaptic(type: HapticType) {
         
         if User.instance.haptics_on {
             switch type {
                 case .light:
                     let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
                     generator.impactOccurred()
                 case .medium:
                     let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.medium)
                     generator.impactOccurred()
                 case .heavy:
                     let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
                     generator.impactOccurred()
                 case .rigid:
                     let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.rigid)
                     generator.impactOccurred()
                 case .soft:
                     let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.soft)
                     generator.impactOccurred()
                 case .success:
                     let generator = UINotificationFeedbackGenerator()
                     generator.notificationOccurred(.success)
                 case .warning:
                     let generator = UINotificationFeedbackGenerator()
                     generator.notificationOccurred(.warning)
                 case .error:
                     let generator = UINotificationFeedbackGenerator()
                     generator.notificationOccurred(.error)
             }
         }
     }
 }
 */
