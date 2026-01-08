//
//  CoreDataStack.swift
//  PokeSpin
//
//  Created by Ivan Almada on 10/6/23.
//  Copyright © 2023 Ivan. All rights reserved.
//
//  Note: This file is kept for backward compatibility but is no longer used.
//  Swift Data handles persistence automatically.

import Foundation
import SwiftData

class DataStack {
    static let shared = DataStack()
    
    private init() {}
    
    static func createModelContainer() -> ModelContainer {
        let schema = Schema([Pokemon.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
