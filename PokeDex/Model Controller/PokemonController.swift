//
//  PokemanController.swift
//  PokeDex
//
//  Created by Seschwan on 5/31/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get  = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case otherError
    case badData
}

class PokemonController {
    
    let baseURL = URL(string: "https://pokeapi.co/api/v2/")!
    
    private (set) var pokemanArray = [Pokemon]()
    
    func searchForPokemon(searchTerm: String, completion: @escaping (Pokemon?, Error?) -> Void) {
        let pokemonURL = baseURL.appendingPathComponent("pokemon/\(searchTerm.lowercased())")
        print(pokemonURL.absoluteURL)
        
        var request = URLRequest(url: pokemonURL)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Check this
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("Error with the data")
                completion(nil, error)
                return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let pokemon = try jsonDecoder.decode(Pokemon.self, from: data)
                print(pokemon)
                completion(pokemon, nil)
            } catch {
                NSLog("Error Decoding Pokemon: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    // Should be good to here. 
    
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {  // (Result<UIImage, NetworkError>)
        let imageURL = URL(string: urlString)!
        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let image = UIImage(data: data)!
            completion(.success(image))
            
        }.resume()
    }
    
    func savePokemon(pokemon: Pokemon) {
        self.pokemanArray.append(pokemon)
    }
    
    func delete(pokemon: Pokemon) {
        guard let index = self.pokemanArray.firstIndex(of: pokemon) else { return }
        self.pokemanArray.remove(at: index)
    }
}
