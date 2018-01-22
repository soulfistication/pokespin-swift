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

    func requestJSONString(pokemon: Int, completion: @escaping (DataResponse<String>) -> Void) {
        Alamofire
            .request(Constants.ApiURL.baseURL.rawValue + "/api/v2/pokemon/\(pokemon)")
            .responseString(completionHandler: completion)
    }

    func request(pokemon: Int, completion: @escaping (DataResponse<Any>) -> Void) {
        Alamofire
            .request(Constants.ApiURL.baseURL.rawValue + "/api/v2/pokemon/\(pokemon)")
            .responseJSON { (response) in
                completion(response)
        }
    }

}
