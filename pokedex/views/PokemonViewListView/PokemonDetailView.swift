//
//  PokemonDetailView.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/20/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import SwiftUI
import PokemonAPI

class PokemonDetailViewModel {
    var pokemon: PKMPokemon
    
    init() {
        self.pokemon = PKMPokemon.defaultValue
    }
}


struct PokemonDetailView: View {
    var pokemon: PKMPokemon?
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView()
    }
}


extension PKMPokemon {
    static var defaultValue: PKMPokemon {
        let pokemon = try! PKMPokemon(from: PKMPokemon.decoder as! Decoder)
        
        return pokemon
    }
}
