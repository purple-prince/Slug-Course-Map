//
//  PreviewsSample.swift
//  Slug Course Map
//
//  Created by Charlie Reeder on 7/26/23.
//

import SwiftUI
import SwiftData

let sampleData = [
    CourseDataModel(code: "writ 1")
]

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: CourseDataModel.self, ModelConfiguration(inMemory: true))
        
        for i in sampleData {
            container.mainContext.insert(object: i)
        }
        
        return container
    } catch {
        fatalError("Failed to create container thing")
    }
}()
