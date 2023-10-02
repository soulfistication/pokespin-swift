//
//  Pokemon.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

struct Pokemon: Codable {

    var id: Int = 0
    var name: String = ""
    var weight: Int = 0
    var height: Int = 0
    var baseExperience: Int = 0

    // MARK: - RLMObject

    static func pokemonIsUnlocked(number: Int) -> Bool {
        return true
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case weight = "weight"
        case height = "height"
        case baseExperience = "base_experience"
    }

}
