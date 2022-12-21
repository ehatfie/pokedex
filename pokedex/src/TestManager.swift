//
//  TestViewModel.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/13/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import Foundation
import PokemonAPI

/**
 This should handle fetching and displaying data
 **/

protocol TestManagerProtocol {
    func fetchPokedexList()
    func loadData() async throws
}

class TestManager: ObservableObject, TestManagerProtocol {
    @Published var pokedexList: [PKMPokedex] = []
    
    let pokedexKey = "PokedexData"
    
    func loadData() async throws {
        print("load data")
//        if let existingData = UserDefaultsHelper.getData(for: pokedexKey) {
//            print("using existing data")
//            let decoder = JSONDecoder()
//
//            do {
//                let pagedObject = try decoder.decode(PKMPagedObject<PKMPokedex>.self, from: existingData)
//                let pokedexData = try await handleResponseAsync(response: pagedObject)
//                print("saved object page count ", pagedObject.pages)
//                setPokedexList(to: pokedexData)
//            } catch let err {
//                print("decoding error ", err.localizedDescription)
//            }
//        } else {
//            try await fetchPokedexListAsync()
//        }
        try await fetchPokedexListAsync()
    }
    
    func setPokedexList(to data: [PKMPokedex]) {
        DispatchQueue.main.async {
            self.pokedexList = data
        }
    }
    
    // goes in some repo?
    func saveFetchResult(data: PKMPagedObject<PKMPokedex>) {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        
        do {
            let data = try encoder.encode(data)
            UserDefaultsHelper.saveData(data: data, key: "PokedexData")
        } catch let err {
            print("Errr ", err.localizedDescription)
        }
    }
    
    func fetchPokedexList() {
        PokemonAPI().gameService.fetchPokedexList(completion: { result in
            switch result {
            case.success(let pokedex):
                print("pokedex: ", pokedex.current)
                self.handleResponse(response: pokedex)
            case .failure(let err):
                print("err ", err.localizedDescription)
            }
        })
    }
    
    func fetchPokedexListAsync() async throws {
        print("fetching pokedex list async")
        let results = try await DataFetcher.fetchPokedexData()
        do {
            let encoder = JSONEncoder()
            encoder.dataEncodingStrategy = .base64
            
            let data = try encoder.encode(results)
            
            print("fetched page count ", results.pages, results.results?.count)
            
            UserDefaultsHelper.saveData(data: data, key: pokedexKey)
        } catch let err {
            print("Errr ", err.localizedDescription)
        }
        
        let objects = try await handleResponseAsync(response: results)
        
        DispatchQueue.main.async {
            self.pokedexList = objects
        }
    }
    
    func handleResponse(response: PKMPagedObject<PKMPokedex>) {
        guard let result = response.results else {
            print("no result")
            return
        }
        let foo = result[0]
        
        let bar = PokemonAPI().resourceService.fetch(foo)
        print("got ", bar)
    }
    
    func handleResponseAsync(response: PKMPagedObject<PKMPokedex>) async throws -> [PKMPokedex] {
        guard let results: [PKMAPIResource<PKMPokedex>] = response.results else {
            print("no result")
            return []
        }
        print("got \(results.count)")
        
        let converted = try await results.asyncMap { entry in
            return try await PokemonAPI().resourceService.fetch(entry)
        }
        
        print("converted \(converted.count)")
        return converted
    }
}

// combine related
extension TestManager {
    
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
