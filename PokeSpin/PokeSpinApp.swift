//
//  PokeSpinApp.swift
//  PokeSpin
//
//  Created by Auto on 2024.
//  Copyright © 2024 Auto. All rights reserved.
//

import SwiftUI

@main
struct PokeSpinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, appDelegate.coreDataStack.managedContext)
        }
    }
}

