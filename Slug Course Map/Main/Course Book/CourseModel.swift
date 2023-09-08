//
//  CourseModel.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/20/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class CourseDataModel: Hashable {
    
    @Attribute(.unique) let code: String
//    var status: CourseStatus
    var status: String
    
    init(code: String) {
        self.code = code
        self.status = "available"
    }
    
    
    
    static func strToStatus(_ str: String) -> CourseStatus {
        switch str {
            case "available": return .available
            case "taken": return .taken
            default: return .taking
        }
    }
    
    static func statusToStr(_ status: CourseStatus) -> String {
        switch status {
            case .available: return "available"
            case .taken: return "taken"
            default: return "taking"
        }
    }
}
