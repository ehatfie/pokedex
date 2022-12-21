//
//  PokemonListViewModel.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/18/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import Foundation
import CoreData
import PokemonAPI

class PokemonListViewModel: ObservableObject {
    @Published var pokemonListData: [TestPokemon] = []
    
    let container = NSPersistentContainer(name: "pokedex")
    
    init() {
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        loadData()
    }
    
    // this might come from the db
    func loadData() {
        let request = NSFetchRequest<TestPokemon>(entityName: "TestPokemon") //exact name as in the CoreData file
            
            do {
                let savedData = try container.viewContext.fetch(request)
                self.pokemonListData = savedData
                //self.pokemonEntries = savedData
                //fetchData()
//                if savedData.count == 0 {
//                    fetchData()
//                }
                print("got saved data? ", savedData.count)
            } catch {
                print("Error getting data. \(error.localizedDescription)")
            }
    }
}

extension PokemonListViewModel {
    func fetchPokemonList() {
        Task {
            //try? await fetchPokemonList()
            try? await testFunction()
        }
    }
    
    private func fetchPokemonList() async throws {
        print("fetchPokemonList()")
        let pagedObject = try await callApi(paginationState: .initial(pageLimit: 10))
        
        guard let results = pagedObject.results else {
            print("no results")
            return
        }
        
        let unwrappedResults = try await results.asyncMap({ resource in
            try await PokemonAPI().resourceService.fetch(resource)
        })
        
        print("got \(unwrappedResults.count) PKPokemon objects \(unwrappedResults.first?.name)")
        
        let nextResults = try await PokemonAPI().pokemonService.fetchPokemonList(paginationState: .continuing(pagedObject, .page(10))).results
        let unwrappedNextResults = try await nextResults?.asyncMap({ resource in
            try await PokemonAPI().resourceService.fetch(resource)
        }).compactMap({ $0 })
        print("unwrapped next results \(unwrappedNextResults?.count) \(unwrappedNextResults?.first?.name)")
        
    }
    
    private func testFunction() async throws {
        var pagedObject = try await callApi(paginationState: .initial(pageLimit: 50))
        
        guard let results = pagedObject.results else {
            print("no results")
            return
        }
        
        let unwrappedResults = try await results.asyncMap({ resource in
            try await PokemonAPI().resourceService.fetch(resource)
        })
        
        insert(data: unwrappedResults)
        
        //var cumulativeResults = [PKMPokemon]()
        //cumulativeResults.append(contentsOf: unwrappedResults)
        //print("cumulative results: \(cumulativeResults.count )")
        
        while(pagedObject.hasNext) {
            print("next page \(pagedObject.current) \(pagedObject.pages)")
            pagedObject = try await callApi(paginationState: .continuing(pagedObject, .next))
            if let results = pagedObject.results {
                let unwrappedResults = try await results.asyncMap({ resource in
                    try await PokemonAPI().resourceService.fetch(resource)
                }).compactMap({ $0 })
                
                insert(data: unwrappedResults)
                print("newly unwrapped results: \(unwrappedResults.count) \(unwrappedResults.first?.name)")
            }
            
            //cumulativeResults.append(contentsOf: unwrappedResults ?? [])
        }
        
       // print("got \(cumulativeResults.count)")
    }
    
    func insert(data: [PKMPokemon]) {
        print("insert \(data.count)")
        data.forEach({ entry in
            let testPokemon = TestPokemon(context: container.viewContext)
            
            guard let pokemon = Pokemon(from: entry) else {
                print("couldnt make pokemon for \(entry)")
                return
            }
            
            testPokemon.name = pokemon.name
            testPokemon.baseExperience = Int16(pokemon.baseExperience)
            testPokemon.height = Int16(pokemon.height)
            testPokemon.order = Int16(pokemon.order)
            testPokemon.weight = Int16(pokemon.weight)
            
            try? container.viewContext.save()
        })
        
        DispatchQueue.main.async {
           // let foo = data.map { Pokemon(from: $0)}.compactMap({ $0 })
            //self.pokemonListData.append(contentsOf: foo)
        }
        
    }
    
    func callApi(paginationState: PaginationState<PKMPokemon>) async throws -> PKMPagedObject<PKMPokemon> {
        return try await PokemonAPI().pokemonService.fetchPokemonList(paginationState: paginationState)
    }
}
