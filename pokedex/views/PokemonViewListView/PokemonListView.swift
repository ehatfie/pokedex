//
//  PokemonListView.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/18/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                print("Press me")
                viewModel.fetchPokemonList()
            }, label: {
                Text("Press Me")
            })
            List(viewModel.pokemonListData, id: \.id) { item in
                HStack {
                    Text(verbatim: "\(item.order)")
                    Text(item.name ?? "")
                }
            }
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(viewModel: PokemonListViewModel())
    }
}
