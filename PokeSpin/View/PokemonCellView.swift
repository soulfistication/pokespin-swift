//
//  PokemonCellView.swift
//  PokeSpin
//
//  Created by Ivan Almada on 2024.
//  Copyright © 2024 Ivan Almada. All rights reserved.
//

import SwiftUI

struct PokemonCellView: View {
    let pokemonNumber: Int
    
    private var pokemon: Pokemon? {
        PokemonManager.fetchPokemon(number: pokemonNumber)
    }
    
    private var isUnlocked: Bool {
        pokemon?.isUnlocked ?? false
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.creamyBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            if isUnlocked {
                Image(String(pokemonNumber))
                    .resizable()
                    .scaledToFit()
                    .padding(8)
            } else {
                VStack {
                    Text("#\(pokemonNumber)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.darkGray)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.systemGray5)
            }
        }
        .frame(height: 100)
    }
}

extension Color {
    static let systemGray5 = Color(uiColor: .systemGray5)
    static let darkGray = Color(uiColor: .darkGray)
}

