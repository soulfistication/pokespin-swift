//
//  Pokemon.swift
//  PokeSpin
//
//  Created by Ivan Almada on 10/6/23.
//  Copyright © 2023 Ivan. All rights reserved.
//

import CoreData

class Pokemon: NSManagedObject, Decodable {
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.weight = try container.decode(Int16.self, forKey: .weight)
        self.height = try container.decode(Int16.self, forKey: .height)
        self.baseExperience = try container.decode(Int16.self, forKey: .baseExperience)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case weight = "weight"
        case height = "height"
        case baseExperience = "base_experience"
    }
    
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}
