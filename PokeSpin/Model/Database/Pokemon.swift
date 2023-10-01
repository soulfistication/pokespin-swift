//
//  Pokemon.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import RealmSwift

class Pokemon: Object, Codable {

    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var weight: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var baseExperience: Int = 0

    // MARK: - Initializers


    // MARK: - RLMObject

    override static func primaryKey() -> String? {
        return "id"
    }

    static func pokemonIsUnlocked(number: Int) -> Bool {
        guard let realm = try? Realm() else { return false }
        return realm.object(ofType: Pokemon.self, forPrimaryKey: number) != nil ? true : false
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
