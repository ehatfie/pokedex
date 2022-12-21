//
//  PokedexView.swit.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/13/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import SwiftUI
import PokemonAPI
import Combine
import CoreData // move

struct PokedexDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var viewModel: PokedexDetailViewModel
    
    var body: some View {
        HStack {
            VStack {
                Text(viewModel.testObject.name ?? "")
                List(viewModel.pokemonEntries, id: \.entryNumber) { item in
                    HStack {
                        Text(verbatim: "\(item.entryNumber)")
                        Text(item.pokemonSpecies ?? "")
                    }
                    
                }
            }
        }
        
    }
    
    func test() {
        
    }
}

struct PokedexDetailView_swit_Previews: PreviewProvider {
    static var previews: some View {
        PokedexDetailView(viewModel: PokedexDetailViewModel(dex: TestPokedex()))
    }
}


extension PKMPokedex {
    static var defaultValue: PKMPokedex {
        let returnValue = try! PKMPokedex(from: PKMPokedex.decoder as! Decoder)
        
        returnValue.name = "DefaultName"
        returnValue.id = 0
        returnValue.pokemonEntries = []
        
        return returnValue
    }
}

// move
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "pokedex")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

// move
class PokedexDetailViewModel: ObservableObject {
    @Published var pokemonEntries: [TestPokemonEntry]
    
    let container = NSPersistentContainer(name: "pokedex")
    
    var testObject: TestPokedex
    
    init(dex: TestPokedex) {
        self.testObject = dex
        self.pokemonEntries = []
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        loadData()
        
        //print("got entries ", entries.count)
    }
    
    func fetchData() {
        print("fetching data")
        guard let pokedexName = testObject.name else {
            print("no name for pokedex \(testObject.id)")
            return
        }
        
        Task {
            guard let fetchedPokedex = try? await PokemonAPI().gameService.fetchPokedex(Int(testObject.id)),
                  let entries = fetchedPokedex.pokemonEntries
            else {
                print("no fetched pokedex")
                return
            }
            
            
            print("got fetched pokedex")
            try? await processEntries(entries: entries)
            
        }
    }
    
    // this might come from the db
    func loadData() {
        let request = NSFetchRequest<TestPokemonEntry>(entityName: "TestPokemonEntry") //exact name as in the CoreData file
            
            do {
                let savedData = try container.viewContext.fetch(request)
                self.pokemonEntries = savedData
                fetchData()
//                if savedData.count == 0 {
//                    fetchData()
//                }
                print("got saved data? ", savedData.count)
            } catch {
                print("Error getting data. \(error.localizedDescription)")
            }
    }
    
    func processEntries(entries: [PKMPokemonEntry]) async throws {
        let numEntries = entries.count
        let someEntries = entries[0 ... (numEntries/2)]
        
        print("got \(entries.count) entries processing \(someEntries.count)")
        let unwrappedEntries = try await someEntries.asyncMap { value in
            return try await PokemonEntry(from: value)
        }.compactMap({ $0 })
        
        print("got unwrapped entries \(unwrappedEntries.count)")
        
        //	saveEntries(entries: unwrappedEntries)
        
//        DispatchQueue.main.async {
//            self.pokemonEntries = unwrappedEntries
//        }
        
        
        //let foo = unwrappedEntries.first?.pokemonSpecies
        
//        let dispatchGroup = DispatchGroup()
//        
//        dispatchGroup.notify(queue: .main, execute: {
//            
//        })
//        
        
    }
    
    func saveEntries(entries: [PokemonEntry]) {
        print("saving \(entries.count)")
        for entry in entries {
            let testPokemonEntry = TestPokemonEntry(context: self.container.viewContext)
            testPokemonEntry.entryNumber = Int16(entry.entryNumber)
            testPokemonEntry.pokemonSpecies = entry.pokemonSpecies.name
            
            try? self.container.viewContext.save()
        }
    }
}
