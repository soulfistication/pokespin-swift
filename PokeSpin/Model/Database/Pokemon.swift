//
//  Pokemon.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import ObjectMapper_RealmSwift

class Pokemon: Object, Mappable {

    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var weight: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var baseExperience: Int = 0

    // MARK: - Initializers

    required convenience init?(map: Map) {
        self.init()
    }

    // MARK: - RLMObject

    override static func primaryKey() -> String? {
        return "id"
    }

    static func pokemonIsUnlocked(number: Int) -> Bool {

        let realm = try! Realm()

        if realm.object(ofType: Pokemon.self, forPrimaryKey: number) != nil {
            return true
        } else {
            return false
        }

    }

    // MARK: - Object Mapper

    func mapping(map: Map) {
        id             <- map["id"]
        name           <- map["name"]
        weight         <- map["weight"]
        height         <- map["height"]
        baseExperience <- map["base_experience"]
    }

}
