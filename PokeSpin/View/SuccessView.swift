//
//  SuccessView.swift
//  PokeSpin
//
//  Created by Ivan Almada on 2024.
//  Copyright © 2024 Ivan Almada. All rights reserved.
//

import SwiftUI

struct SuccessView: View {
    let pokemonNumber: Int
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var pokemon: Pokemon? = nil
    @State private var isLoading = true
    @State private var scale: CGFloat = 0.1
    
    private let client = NetworkClient()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.creamyBlue
                    .ignoresSafeArea()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let pokemon = pokemon {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        // Pokemon image with animation
                        Image(String(pokemonNumber))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .scaleEffect(scale)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: scale)
                        
                        // Pokemon name
                        Text(pokemon.name!.capitalized)
                            .font(.system(size: 28, weight: .bold))
                            .scaleEffect(scale == 1.0 ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.5).delay(0.3), value: scale)
                        
                        // Pokemon details
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Weight: \(pokemon.weight) kg")
                            Text("Height: \(pokemon.height) cm")
                            Text("Base Experience: \(pokemon.baseExperience)")
                        }
                        .font(.system(size: 18))
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Pokemon Unlocked!")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                        onDismiss()
                    }
                }
            }
        }
        .task {
            await loadPokemon()
        }
    }
    
    @MainActor
    private func loadPokemon() async {
        // Check if already unlocked
        if let existingPokemon = PokemonManager.fetchPokemon(number: pokemonNumber),
           existingPokemon.isUnlocked {
            self.pokemon = existingPokemon
            self.isLoading = false
            self.scale = 1.0
            return
        }
        
        // Fetch from API
        do {
            let pokemonData = try await client.requestJSON(pokemon: pokemonNumber)
            let decoder = JSONDecoder()
            let pokemonDTO = try decoder.decode(PokemonDTO.self, from: pokemonData)
            let pokemon = pokemonDTO.toPokemon()
            pokemon.isUnlocked = true
            self.pokemon = pokemon
            PokemonManager.add(pokemon: pokemon)
            
            withAnimation {
                isLoading = false
                scale = 1.0
            }
        } catch {
            print("Error fetching Pokemon: \(error)")
            isLoading = false
        }
    }
}

