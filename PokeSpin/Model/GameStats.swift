//
//  GameStats.swift
//  PokeSpin
//
//  Created by Auto on 2024.
//  Copyright © 2024 Auto. All rights reserved.
//

import Foundation

class GameStats {
    static let shared = GameStats()
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let totalSpins = "totalSpins"
        static let totalWins = "totalWins"
        static let totalLosses = "totalLosses"
        static let lastSpinDate = "lastSpinDate"
        static let energy = "energy"
        static let maxEnergy = "maxEnergy"
    }
    
    var totalSpins: Int {
        get { userDefaults.integer(forKey: Keys.totalSpins) }
        set { userDefaults.set(newValue, forKey: Keys.totalSpins) }
    }
    
    var totalWins: Int {
        get { userDefaults.integer(forKey: Keys.totalWins) }
        set { userDefaults.set(newValue, forKey: Keys.totalWins) }
    }
    
    var totalLosses: Int {
        get { userDefaults.integer(forKey: Keys.totalLosses) }
        set { userDefaults.set(newValue, forKey: Keys.totalLosses) }
    }
    
    var winRate: Double {
        guard totalSpins > 0 else { return 0.0 }
        return Double(totalWins) / Double(totalSpins) * 100.0
    }
    
    var collectionProgress: Double {
        let unlockedCount = PokemonManager.fetchPokemons().filter { $0.isUnlocked }.count
        return Double(unlockedCount) / Double(Constants.numberOfPokemonsDisplayed) * 100.0
    }
    
    var energy: Int {
        get {
            let saved = userDefaults.integer(forKey: Keys.energy)
            let maxEnergy = self.maxEnergy
            // Regenerate energy if needed (1 energy per hour, max 5)
            if let lastDate = userDefaults.object(forKey: Keys.lastSpinDate) as? Date {
                let hoursSince = Date().timeIntervalSince(lastDate) / 3600
                let regenerated = min(Int(hoursSince), maxEnergy - saved)
                if regenerated > 0 {
                    let newEnergy = min(saved + regenerated, maxEnergy)
                    userDefaults.set(newEnergy, forKey: Keys.energy)
                    return newEnergy
                }
            }
            return saved > 0 ? saved : maxEnergy
        }
        set {
            userDefaults.set(newValue, forKey: Keys.energy)
            userDefaults.set(Date(), forKey: Keys.lastSpinDate)
        }
    }
    
    var maxEnergy: Int {
        get { userDefaults.integer(forKey: Keys.maxEnergy) > 0 ? userDefaults.integer(forKey: Keys.maxEnergy) : 5 }
        set { userDefaults.set(newValue, forKey: Keys.maxEnergy) }
    }
    
    func recordSpin(win: Bool) {
        totalSpins += 1
        if win {
            totalWins += 1
        } else {
            totalLosses += 1
        }
        energy = max(0, energy - 1)
    }
    
    func reset() {
        totalSpins = 0
        totalWins = 0
        totalLosses = 0
        energy = maxEnergy
    }
    
    private init() {
        // Initialize energy if first launch
        if userDefaults.object(forKey: Keys.energy) == nil {
            energy = maxEnergy
        }
    }
}

