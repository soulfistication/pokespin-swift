//
//  IntroView.swift
//  PokeSpin
//
//  Created by Ivan Almada on 2024.
//  Copyright © 2024 Ivan Almada. All rights reserved.
//

import SwiftUI

struct IntroView: View {
    @State private var showResetAlert = false
    @State private var unlockedCount = 0
    
    private let gameStats = GameStats.shared
    
    var body: some View {
        ZStack {
            Color.creamyBlue
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Logo or title
                Text("Welcome to PokeSpin! 🎰")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Info text
                VStack(alignment: .leading, spacing: 12) {
                    Text("Spin the slot machine to collect all 18 Pokemon!")
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Progress:")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("• Collected: \(unlockedCount)/\(Constants.numberOfPokemonsDisplayed)")
                        Text("• Total Spins: \(gameStats.totalSpins)")
                        Text("• Win Rate: \(String(format: "%.1f", gameStats.winRate))%")
                        Text("• Energy: \(gameStats.energy)/\(gameStats.maxEnergy)")
                    }
                    .font(.system(size: 16))
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white.opacity(0.3))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    NavigationLink(destination: PokemonCollectionView()) {
                        Text("View Pokédex")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        showResetAlert = true
                    }) {
                        Text("Reset Progress")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            updateStats()
        }
        .alert("Confirm reset progress.", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset progress", role: .destructive) {
                resetProgress()
            }
        } message: {
            Text("Are you sure you want to erase your precious Pokemon?")
        }
    }
    
    private func updateStats() {
        unlockedCount = PokemonManager.fetchPokemons().filter { $0.isUnlocked }.count
    }
    
    private func resetProgress() {
        PokemonManager.deletePokemons()
        updateStats()
    }
}

