//
//  IPokemonStorage.swift
//  PokeSpin
//
//  Created by Ivan Almada on 10/18/23.
//  Copyright © 2023 Ivan. All rights reserved.
//

protocol IPokemonStorage {
    static func add(pokemon: Pokemon)
    static func fetchPokemon(number: Int) -> Pokemon?
    static func fetchPokemons() -> [Pokemon]
    static func deletePokemon(number: Int)
    static func deletePokemons()
}
