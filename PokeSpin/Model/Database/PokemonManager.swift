//
//  PokemonManager.swift
//  PokeSpin
//
//  Created by Ivan on 10/4/23.
//  Copyright © 2023 Ivan. All rights reserved.
//

import Foundation

protocol IPokemonStorage {
    static func addPokemon(pokemon: Pokemon)
    static func fetchPokemon(number: Int) -> Pokemon?
    static func deleteAllPokemon()
}

struct PokemonManager: IPokemonStorage {
    
    static func fetchPokemon(number: Int) -> Pokemon? {
        return nil
    }
    
    static func addPokemon(pokemon: Pokemon) {
        
    }
    
    static func deleteAllPokemon() {
        
    }

}
