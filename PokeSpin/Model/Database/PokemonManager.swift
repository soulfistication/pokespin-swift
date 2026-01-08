//
//  PokemonManager.swift
//  PokeSpin
//
//  Created by Ivan Almada on 10/4/23.
//  Copyright © 2023 Ivan Almada. All rights reserved.
//

import UIKit
import SwiftData

struct PokemonManager: IPokemonStorage {

    static func getModelContext() -> ModelContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.modelContext
    }

    static func fetchPokemon(number: Int) -> Pokemon? {
        guard let modelContext = getModelContext() else { return nil }
        
        let descriptor = FetchDescriptor<Pokemon>(
            predicate: #Predicate<Pokemon> { $0.id == Int64(number) }
        )
        
        do {
            let results = try modelContext.fetch(descriptor)
            return results.first
        } catch {
            print("Error fetching Pokemon: \(error)")
            return nil
        }
    }

    static func add(pokemon: Pokemon) {
        guard let modelContext = getModelContext() else { return }
        
        DispatchQueue.main.async {
            modelContext.insert(pokemon)
            do {
                try modelContext.save()
            } catch {
                print("Error saving Pokemon: \(error)")
            }
        }
    }

    static func fetchPokemons() -> [Pokemon] {
        guard let modelContext = getModelContext() else { return [Pokemon]() }
        
        let descriptor = FetchDescriptor<Pokemon>()
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching Pokemons: \(error)")
            return [Pokemon]()
        }
    }

    static func deletePokemon(number: Int) {
        guard let modelContext = getModelContext() else { return }
        guard let pokemon = self.fetchPokemon(number: number) else { return }
        
        modelContext.delete(pokemon)
        
        do {
            try modelContext.save()
        } catch {
            print("Error deleting Pokemon: \(error)")
        }
    }

    static func deletePokemons() {
        guard let modelContext = getModelContext() else { return }
        
        let pokemons = PokemonManager.fetchPokemons()
        pokemons.forEach { modelContext.delete($0) }
        
        do {
            try modelContext.save()
        } catch {
            print("Error deleting Pokemons: \(error)")
        }
    }

}
