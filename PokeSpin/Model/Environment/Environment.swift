//
//  Environment.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import Foundation

struct Environment {
    static func isDevelopmentEnvironment() -> Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}
