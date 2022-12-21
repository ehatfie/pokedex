//
//  ApiCaller+PokemonList.swift
//  pokedex
//
//  Created by Erik Hatfield on 6/25/20.
//  Copyright © 2020 Erik Hatfield. All rights reserved.
//

import Foundation


extension ApiCaller {
    func getPokemonList(limit: Int, offset: Int, success: @escaping (FetchPokemonResponseOuter) -> Void, failure: @escaping() -> Void = {}) {
        let urlString = baseUrlString + "?limit=\(limit)&offset=\(offset)"
        self.callUrl(urlString: urlString, success: { data in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print()
                
                let next = json["next"] as? String
                let previous = json["previous"] as? String
                guard let count = json["count"] as? Int64 else { return }
                guard let results = json["results"] as? [[String: AnyObject]] else { return } // throw error?
                var pokemonNumber: Int = offset
                let resultInners = results.compactMap { result -> FetchPokemonResponseInner? in
                    pokemonNumber += 1
                    guard let name = result["name"] as? String else { return nil }
                    guard let url = result["url"] as? String else { return nil }
                    
                    return FetchPokemonResponseInner(name: name, url: url, number: pokemonNumber)
                }
                
                let resultOuter = FetchPokemonResponseOuter(next: next, previous: previous, count: count, results: resultInners)
                success(resultOuter)
                // check if the numbers match?
            } catch let error {
                print("ERROR \(error)")
            }
            
        }, failure: {
            
        })
    }
    
    func callUrl(urlString: String, success: @escaping (Data?) -> Void, failure: @escaping () -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.url = url
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                success(data)
            } else {
                failure()
            }
        })
        
        task.resume()
    }
}

// this will probably be a fetch from a db eventually
struct FetchPokemonResponseOuter {
    let next: String?
    let previous: String?
    let count: Int64
    let results: [FetchPokemonResponseInner]
    
    init(next: String?, previous: String?, count: Int64, results: [FetchPokemonResponseInner]) {
        self.next = next
        self.previous = previous
        self.count = count
        self.results = results
    }
}

struct FetchPokemonResponseInner {
    let name: String
    let url: String
    let number: Int
    
    init(name: String, url: String, number: Int) {
        self.name = name
        self.url = url
        self.number = number
    }
}
