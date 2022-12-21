//
//  PokemonEntryView.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/14/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import SwiftUI
import PokemonAPI

class PokemonEntryViewModel: ObservableObject {
    @Published var pokemonEntries: [PokemonEntry]
    
    var pokedex: PKMPokedex?
    
    init() {
        pokemonEntries = []
    }
    
    init(pokedex: PKMPokedex) {
        self.pokemonEntries = []
        self.pokedex = pokedex
        
        print("pokedex pokemon count ", pokedex.pokemonEntries?.count)
        
        Task {
            try? await unpack()
        }
    }
    
    func unpack() async throws {
        
        guard let pokemonEntries = pokedex?.pokemonEntries else {
            print("Found no pokemon entries for \(pokedex?.name ?? "NO NAME")")
            return
        }
        
        let subsetEntries = Array(pokemonEntries[0...30])
        
        let unwrappedEntries = await subsetEntries.asyncMap({ value -> PokemonEntry? in
                return try? await PokemonEntry(from: value)
            })
        let foo = unwrappedEntries[0]?.pokemonSpecies
        print("pokemon species? ", foo)
        DispatchQueue.main.async { [weak self] in
            print("setting pokemon entries")
            self?.pokemonEntries = unwrappedEntries.compactMap({ $0 })
        }
    }
}

struct PokemonEntryView: View {
    @ObservedObject var viewModel: PokemonEntryViewModel
    
    
    var body: some View {
        List(viewModel.pokemonEntries, id: \.entryNumber) { item in
            if let species = item.pokemonSpecies,
               let name = species.name {
                Text(name)
            }
        }
    }
}



struct PokemonEntryView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonEntryView(viewModel: PokemonEntryViewModel())
    }
}
