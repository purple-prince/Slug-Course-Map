//
//  Course.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/24/23.
//

import Foundation

enum CourseStatus: String, Codable {
    case available, taken, taking
}

struct Course: Identifiable {
    let id = UUID().uuidString
    
    let title: String
    let code: String
    let credits: Int
    let description: String
    let quartersOffered: String?
    let instructor: String?
    let genEdCode: String?
    let repeatableForCredit: Bool?
    let preReqCodes: String?
}






