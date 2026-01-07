//
//  SlotMachineView.swift
//  PokeSpin
//
//  Created by Ivan Almada on 2024.
//  Copyright © 2024 Ivan Almada. All rights reserved.
//

import SwiftUI

struct SlotMachineView: View {
    let pokemonNumber: Int
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedRows: [Int] = [4, 4, 4]
    @State private var isSpinning = false
    @State private var showWinAlert = false
    @State private var showLossAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showSuccess = false
    
    private let gameStats = GameStats.shared
    private let hapticGenerator = UINotificationFeedbackGenerator()
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.creamyBlue
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Pokemon number label
                    Text("Pokemon #\(pokemonNumber)")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top)
                    
                    // Energy and stats
                    VStack(spacing: 8) {
                        Text("⚡ Energy: \(gameStats.energy)/\(gameStats.maxEnergy)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(gameStats.energy > 0 ? .green : .red)
                        
                        let winRate = String(format: "%.1f", gameStats.winRate)
                        Text("Spins: \(gameStats.totalSpins) | Wins: \(gameStats.totalWins) | Win Rate: \(winRate)%")
                            .font(.system(size: 14))
                            .foregroundColor(.darkGray)
                    }
                    .padding(.horizontal)
                    
                    // Slot machine picker
                    HStack(spacing: 20) {
                        ForEach(0..<Constants.numberOfColumnsInSlotMachine, id: \.self) { index in
                            SlotWheel(selectedRow: $selectedRows[index], isSpinning: $isSpinning)
                        }
                    }
                    .padding()
                    
                    // Win label (hidden by default)
                    if showWinAlert {
                        Text("🎉 WINNER! 🎉")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.green)
                            .transition(.scale)
                    }
                    
                    Spacer()
                    
                    // Spin button
                    Button(action: {
                        spin()
                    }) {
                        Text("SPIN")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(gameStats.energy > 0 && !isSpinning ? Color.blue : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(gameStats.energy == 0 || isSpinning)
                    .opacity(gameStats.energy > 0 && !isSpinning ? 1.0 : 0.5)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Slot Machine")
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
        .onAppear {
            hapticGenerator.prepare()
            impactGenerator.prepare()
        }
        .alert(alertTitle, isPresented: $showLossAlert) {
            Button("OK") {
                dismiss()
                onDismiss()
            }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(isPresented: $showSuccess) {
            SuccessView(pokemonNumber: pokemonNumber) {
                dismiss()
                onDismiss()
            }
        }
    }
    
    private func spin() {
        guard gameStats.energy > 0 else {
            alertTitle = "No Energy"
            alertMessage = "You need energy to spin! Energy regenerates over time (1 per hour)."
            showLossAlert = true
            return
        }
        
        isSpinning = true
        showWinAlert = false
        impactGenerator.impactOccurred()
        
        // Animate each wheel with different timings
        let baseRow = Int.random(in: 12...24)
        let firstFinalRow = baseRow + Int.random(in: 20...30)
        let secondFinalRow = baseRow + Int.random(in: 25...35)
        let thirdFinalRow = baseRow + Int.random(in: 30...40)
        
        // Animate wheels with staggered timing
        selectedRows[0] = firstFinalRow
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            selectedRows[1] = secondFinalRow
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            selectedRows[2] = thirdFinalRow
        }
        
        // Calculate results after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            let firstSymbol = slotSymbol(row: firstFinalRow)
            let secondSymbol = slotSymbol(row: secondFinalRow)
            let thirdSymbol = slotSymbol(row: thirdFinalRow)
            
            let firstHit = firstSymbol == secondSymbol
            let secondHit = secondSymbol == thirdSymbol
            let thirdHit = firstSymbol == thirdSymbol
            
            let successHit = firstHit && secondHit
            
            // Record the spin
            gameStats.recordSpin(win: successHit)
            isSpinning = false
            
            if successHit {
                hapticGenerator.notificationOccurred(.success)
                withAnimation {
                    showWinAlert = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showSuccess = true
                }
            } else {
                hapticGenerator.notificationOccurred(.error)
                var message = "You lost! Please try again."
                var title = "Try Again"
                
                if firstHit || secondHit || thirdHit {
                    message = "So close! You matched 2 symbols. Try again!"
                    title = "Almost There!"
                }
                
                alertTitle = title
                alertMessage = message
                showLossAlert = true
            }
        }
    }
    
    private func slotSymbol(row: Int) -> String {
        if row % 4 == 0 {
            return "♠️"
        } else if row % 4 == 1 {
            return "♥️"
        } else if row % 4 == 2 {
            return "♣️"
        } else if row % 4 == 3 {
            return "♦️"
        }
        return "💊"
    }
}

struct SlotWheel: View {
    @Binding var selectedRow: Int
    @Binding var isSpinning: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(0..<Constants.numberOfRowsInSlotMachine, id: \.self) { row in
                            Text(slotSymbol(row: row))
                                .font(.system(size: 40))
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .id(row)
                        }
                    }
                }
                .scrollDisabled(true)
                .onChange(of: selectedRow) { newValue in
                    withAnimation(.easeOut(duration: 1.5)) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
                .onAppear {
                    proxy.scrollTo(selectedRow, anchor: .center)
                }
            }
        }
        .frame(width: 80, height: 240)
        .background(Color.white.opacity(0.3))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue, lineWidth: 2)
        )
        .overlay(
            // Selection indicator
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 80)
                    .foregroundColor(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.green, lineWidth: 3)
                    )
                Spacer()
            }
        )
        .clipped()
    }
    
    private func slotSymbol(row: Int) -> String {
        if row % 4 == 0 {
            return "♠️"
        } else if row % 4 == 1 {
            return "♥️"
        } else if row % 4 == 2 {
            return "♣️"
        } else if row % 4 == 3 {
            return "♦️"
        }
        return "💊"
    }
}

