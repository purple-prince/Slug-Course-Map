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
    
    // TODO: do we want to not allow for more than one rating, or do we want to replace the course rating after each repeated rate?
    
    @Attribute(.unique) let code: String
//    var status: CourseStatus
    var status: String
  //  var rated: Bool
    
    init(code: String) {
        self.code = code
        self.status = "available"
        //self.rated = false
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
