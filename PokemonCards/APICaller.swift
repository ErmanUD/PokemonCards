//
//  APICaller.swift
//  PokemonCards
//
//  Created by Erman Ufuk Demirci on 12.09.2022.
//

import Foundation
import UIKit

final class APICaller {
    static let shared = APICaller()
    
    private var pokemonNumber = 1

    enum APIError: Error {
        case failedToGetData
        case failedToParse
        case failedToGetImage
    }

    private func createRequest(with url: URL?,
                               completion: @escaping (URLRequest) -> Void) {
        guard let url = url else {
            return
        }
        
        let request = URLRequest(url: url)
        completion(request)
    }

    public func getPokemon(completion: @escaping (Result<Pokemon, Error>) -> Void) {
        createRequest(with: URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonNumber)")) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(Pokemon.self, from: data)
                    completion(.success(result))
                    
                } catch {
                    completion(.failure(APIError.failedToParse))
                }
            }
            task.resume()
        }
        pokemonNumber = Int.random(in: 1...300)
    }
}
