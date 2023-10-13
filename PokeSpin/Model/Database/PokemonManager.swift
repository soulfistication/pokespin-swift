//
//  PokemonManager.swift
//  PokeSpin
//
//  Created by Ivan on 10/4/23.
//  Copyright © 2023 Ivan. All rights reserved.
//

import UIKit

protocol IPokemonStorage {
    static func addPokemon(pokemon: Pokemon)
    static func fetchPokemon(number: Int) -> Pokemon?
    static func fetchAllPokemons() -> [Pokemon]
    static func deleteAllPokemon()
}

struct PokemonManager: IPokemonStorage {

    static let appDelegate = UIApplication.shared.delegate as? AppDelegate

    static func fetchPokemon(number: Int) -> Pokemon? {
        guard let appDelegate = appDelegate else { return nil }
        let managedContext = appDelegate.coreDataStack.managedContext
        let pokemonFetchRequest = Pokemon.fetchRequest()
        do {
            let fetchResults = try managedContext.fetch(pokemonFetchRequest)
            let filtered = fetchResults.filter { $0.id == number }
            return filtered.first
        } catch (let error as NSError) {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }

    static func addPokemon(pokemon: Pokemon) {
        guard let appDelegate = appDelegate else { return }

        DispatchQueue.main.async {
            let managedContext = appDelegate.coreDataStack.managedContext
            do {
                try managedContext.save()
            } catch (let error) {
                print(String(describing: error))
            }
        }
    }

    static func fetchAllPokemons() -> [Pokemon] {
        guard let appDelegate = appDelegate else { return [Pokemon]() }

        let managedContext = appDelegate.coreDataStack.managedContext
        let pokemonFetchRequest = Pokemon.fetchRequest()
        do {
            let fetchResults = try managedContext.fetch(pokemonFetchRequest)
            return fetchResults
        } catch (let error as NSError) {
            print("Fetch All error: \(error) description: \(error.userInfo)")
        }
        return [Pokemon]()
    }

    static func deleteAllPokemon() {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.coreDataStack.managedContext
        let allPokemons = PokemonManager.fetchAllPokemons()
        for pokemon in allPokemons {
            managedContext.delete(pokemon)
        }
        do {
            try managedContext.save()
        } catch (let error as NSError) {
            print("Delete All error: \(error) description: \(error.userInfo)")
        }
    }

}
