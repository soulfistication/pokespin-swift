//
//  Pokemon.swift
//  PokeSpin
//
//  Created by Ivan Almada on 10/6/23.
//  Copyright © 2023 Ivan. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Pokemon {
    var id: Int64
    var name: String
    var weight: Int16
    var height: Int16
    var baseExperience: Int16
    var isUnlocked: Bool
    
    init(id: Int64, name: String, weight: Int16, height: Int16, baseExperience: Int16, isUnlocked: Bool = false) {
        self.id = id
        self.name = name
        self.weight = weight
        self.height = height
        self.baseExperience = baseExperience
        self.isUnlocked = isUnlocked
    }
}

// Helper struct for decoding JSON, then convert to Pokemon model
struct PokemonDTO: Decodable {
    let id: Int64
    let name: String
    let weight: Int16
    let height: Int16
    let baseExperience: Int16
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case weight = "weight"
        case height = "height"
        case baseExperience = "base_experience"
    }
    
    func toPokemon() -> Pokemon {
        Pokemon(id: id, name: name, weight: weight, height: height, baseExperience: baseExperience, isUnlocked: false)
    }
}
