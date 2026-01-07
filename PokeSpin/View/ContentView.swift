//
//  ContentView.swift
//  PokeSpin
//
//  Created by Ivan Almada on 2024.
//  Copyright © 2024 Ivan Almada. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            IntroView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

