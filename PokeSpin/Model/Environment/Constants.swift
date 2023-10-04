//
//  Constants.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import Foundation

struct Constants {
    
    static let numberOfPokemonsDisplayed = 18
    
    enum SegueIdentifier: String {
        case openSlotMachine = "ELSegueIdentifierOpenSlotMachine";
        case openSuccess = "ELSegueIdentifierOpenSuccessSlotMachine";
        case openPokemonUnlocked = "ELSegueIdentifierOpenPokemonUnlocked";
        case openPokeDex = "ELSegueIdentifierOpenPokeDex";
    }

    enum CellIdentifiers: String {
        case pokemonCollectionViewCell = "ELCellIdentifierPokemonCollectionViewCell"
    }

    enum ApiURL: String {
        case baseURL = "https://pokeapi.co";
        case pokemonEndpoint = "pokemon";
    }
}
