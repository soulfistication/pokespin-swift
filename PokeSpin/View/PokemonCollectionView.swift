//
//  PokemonCollectionView.swift
//  PokeSpin
//
//  Created by Auto on 2024.
//  Copyright © 2024 Auto. All rights reserved.
//

import SwiftUI

struct PokemonCollectionView: View {
    @State private var showStats = false
    @State private var unlockedCount = 0
    @State private var selectedPokemon: Int? = nil
    @State private var showSlotMachine = false
    @State private var showSuccess = false
    
    private let gameStats = GameStats.shared
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color.creamyBlue
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress section
                VStack(spacing: 12) {
                    ProgressView(value: gameStats.collectionProgress / 100.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .padding(.horizontal)
                    
                    Text("Collection: \(unlockedCount)/\(Constants.numberOfPokemonsDisplayed) (\(String(format: "%.0f", gameStats.collectionProgress))%)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.darkGray)
                }
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Collection grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(1...Constants.numberOfPokemonsDisplayed, id: \.self) { pokemonNumber in
                            PokemonCellView(pokemonNumber: pokemonNumber)
                                .onTapGesture {
                                    handlePokemonTap(pokemonNumber: pokemonNumber)
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Pokédex")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Stats") {
                    showStats = true
                }
            }
        }
        .onAppear {
            updateProgress()
        }
        .sheet(isPresented: $showSlotMachine) {
            if let pokemonNumber = selectedPokemon {
                SlotMachineView(pokemonNumber: pokemonNumber) {
                    updateProgress()
                }
            }
        }
        .sheet(isPresented: $showSuccess) {
            if let pokemonNumber = selectedPokemon {
                SuccessView(pokemonNumber: pokemonNumber) {
                    updateProgress()
                }
            }
        }
        .alert("Game Statistics", isPresented: $showStats) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(statsMessage)
        }
    }
    
    private var statsMessage: String {
        let stats = gameStats
        return """
        📊 Game Statistics
        
        Total Spins: \(stats.totalSpins)
        Wins: \(stats.totalWins)
        Losses: \(stats.totalLosses)
        Win Rate: \(String(format: "%.1f", stats.winRate))%
        
        Collection Progress: \(String(format: "%.0f", stats.collectionProgress))%
        Energy: \(stats.energy)/\(stats.maxEnergy)
        """
    }
    
    private func updateProgress() {
        unlockedCount = PokemonManager.fetchPokemons().filter { $0.isUnlocked }.count
    }
    
    private func handlePokemonTap(pokemonNumber: Int) {
        selectedPokemon = pokemonNumber
        let pokemon = PokemonManager.fetchPokemon(number: pokemonNumber)
        let isUnlocked = pokemon?.isUnlocked ?? false
        
        if isUnlocked {
            showSuccess = true
        } else {
            showSlotMachine = true
        }
    }
}

