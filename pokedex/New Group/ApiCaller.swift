//
//  ApiCaller.swift
//  pokedex
//
//  Created by Erik Hatfield on 6/24/20.
//  Copyright © 2020 Erik Hatfield. All rights reserved.
//

import Foundation
import PokemonAPI

class ApiCaller {
    let baseUrlString = "https://pokeapi.co/api/v2/pokemon"
    
    func callApi() {
        guard let url = URL(string: baseUrlString + "/ditto") else { return }
        var request = URLRequest(url: url)
        request.url = url
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            print("GOTEM")
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                for key in json.keys {
                    if key == "stats", let statsArray = json[key] as? [[String: AnyObject]] {
                        // can get from function
                        let outerArray = statsArray.compactMap { val -> StatOuter? in
                            var statInner: StatInner? = nil
                            if let innerStat = val["stat"] as? [String: AnyObject] {
                                if let name = innerStat["name"] as? String, let url = innerStat["url"] as? String {
                                    statInner = StatInner(name: name, url: url)
                                }
                            }
                
                            guard let baseStat = val["base_stat"] as? Int64 else {
                                return nil }
                            guard let effort = val["effort"] as? Int64 else {
                                return nil }
                            guard let stat = statInner else {
                                return nil }
                
                            return StatOuter(baseStat: baseStat, effort: effort, statInner: stat)
                        }
                    } else if key == "" {
                        
                    }
                }
                let result = try JSONDecoder().decode(DecodedArray.self, from: data!)
                //print ("Response \(json)")
                if let something = json["stats"] {
                    if let somethingElse = something as? [String: AnyObject] {
                        print("YA")
                    }
                }
                
                if let stats = json["stats"] as? [[String: AnyObject]] {
                    print("COOOL ")
                    stats.map({ val in
                        val
                    })
                } else {
                    print("NO")
                }
                
            } catch let error {
                print("error")
            }
            })
        task.resume()
        
    }
    
    func callApi1() {
        // Example of calling a web API using an ID
        PokemonAPI().berryService.fetchBerry(1) { result in
            switch result {
            case .success(let berry):
                print("berry ", berry)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        PokemonAPI().gameService.fetchPokedexList(completion: { result in
            switch result {
            case.success(let pokedex):
                print("pokedex: ", pokedex.current)
            case .failure(let err):
                print("err ", err.localizedDescription)
            }
        })

//        let cancellable = PokemonAPI().berryService.fetchBerry(1).sink(receiveCompletion: { completion in
//            if case .failure(let error) = completion {
//                print(error.localizedDescription)
//            }
//        }, receiveValue: { berry in
//            print(" got berry")
//            //self.berryLabel.text = berry.name // cheri
//        })
//        cancel
    }
}

protocol JSONStringConvertible {
    var jsonString: String? {get}
}

extension JSONStringConvertible {
    var jsonString: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        } catch { return nil }
        return nil
    }
}


struct PokemonStruct {
    let name: String
    let stats: [Stat]
}
