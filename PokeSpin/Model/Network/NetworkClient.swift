//
//  NetworkClient.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2023 Ivan. All rights reserved.
//

import Foundation

enum APIError: Error {
    case emptyData
    case wrongEncoding
}

struct NetworkClient {
    
    let baseURL = Constants.ApiURL.baseURL.rawValue
    let apiVersion = "api/v2"
    let endpoint = "pokemon"
    
    func requestJSON(pokemon: Int) async -> Data {
        guard let url = URL(string: "\(baseURL)/\(apiVersion)/\(endpoint)/\(pokemon)") else { return Data() }
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        do {
            let dataTask = try await urlSession.data(from: url)
            return dataTask.0
        } catch (let error) {
            print(String(describing: error))
            return Data()
        }
    }
    
    func requestJSONData(pokemon: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/\(apiVersion)/\(endpoint)/\(pokemon)") else {
            return
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.emptyData))
                return
            }
            
            completion(.success(data))
        }
        
        dataTask.resume()
    }

    func requestJSONString(pokemon: Int, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/\(apiVersion)/\(endpoint)/\(pokemon)") else { return }

        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.emptyData))
                return
            }
            
            guard let result = String(data: data, encoding: .utf8) else {
                completion(.failure(APIError.wrongEncoding))
                return
            }

            completion(.success(result))
        }
        
        dataTask.resume()
    }
}
