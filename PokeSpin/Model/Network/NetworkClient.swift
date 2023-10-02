//
//  NetworkClient.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import Foundation

struct NetworkClient {
    
    let baseURL = Constants.ApiURL.baseURL.rawValue
    let apiVersion = "api/v2"
    let endpoint = "pokemon"

    func requestJSONString(pokemon: Int, completion: @escaping (Result<String, Error>) -> Void) {
        
        
        
//        Alamofire
//            .request(baseURL + "/api/v2/pokemon/\(pokemon)")
//            .responseString(completionHandler: completion)
        
    }


}
