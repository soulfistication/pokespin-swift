//
//  PokemonManager.swift
//  PokeSpin
//
//  Created by Ivan Almada on 10/4/23.
//  Copyright © 2023 Ivan Almada. All rights reserved.
//

import UIKit

struct PokemonManager: IPokemonStorage {

    static let appDelegate = UIApplication.shared.delegate as? AppDelegate

    static func fetchPokemon(number: Int) -> Pokemon? {
        guard let appDelegate else { return nil }
        let managedContext = appDelegate.coreDataStack.managedContext
        let pokemonFetchRequest = Pokemon.fetchRequest()
        do {
            let fetchResults = try managedContext.fetch(pokemonFetchRequest)
            return fetchResults.filter { $0.id == number }.first
        } catch (let error) {
            print(String(describing: error))
        }
        return nil
    }

    static func add(pokemon: Pokemon) {
        guard let appDelegate else { return }

        DispatchQueue.main.async {
            let managedContext = appDelegate.coreDataStack.managedContext
            do {
                try managedContext.save()
            } catch (let error) {
                print(String(describing: error))
            }
        }
    }

    static func fetchPokemons() -> [Pokemon] {
        guard let appDelegate else { return [Pokemon]() }

        let managedContext = appDelegate.coreDataStack.managedContext
        let pokemonFetchRequest = Pokemon.fetchRequest()
        do {
            let fetchResults = try managedContext.fetch(pokemonFetchRequest)
            return fetchResults
        } catch (let error) {
            print(String(describing: error))
        }
        return [Pokemon]()
    }

    static func deletePokemon(number: Int) {
        guard let appDelegate else { return }
        guard let pokemon = self.fetchPokemon(number: number) else { return }

        let managedContext = appDelegate.coreDataStack.managedContext
        managedContext.delete(pokemon)

        do {
            try managedContext.save()
        } catch (let error) {
            print(String(describing: error))
        }
    }

    static func deletePokemons() {
        guard let appDelegate else { return }
        
        let managedContext = appDelegate.coreDataStack.managedContext
        PokemonManager.fetchPokemons().forEach { managedContext.delete($0) }

        do {
            try managedContext.save()
        } catch (let error as NSError) {
            print(String(describing: error))
        }
    }

}
