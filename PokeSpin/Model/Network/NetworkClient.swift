//
//  NetworkClient.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkClient {

    static func request() {
        let pokemonNumber = 2

        Alamofire
            .request(Constants.ApiURL.baseURL.rawValue + "/api/v2/pokemon/\(pokemonNumber)")
            .responseJSON { (response) in

                let value = response.result.value!
                print("The value is: \(value)")

        }
    }

}
