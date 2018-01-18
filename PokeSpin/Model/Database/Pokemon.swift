//
//  Pokemon.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import RealmSwift

class Pokemon: Object {

    @objc dynamic var id: Int = 0
//    var name: String
//    var weight: Int
//    var height: Int
//    var baseExperience: Int

    // MARK: - Initializers


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

}
