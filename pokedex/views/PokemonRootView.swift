//
//  PokemonRootView.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/18/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    var body: some View {
        VStack {
            Text("Search bar here")
                .frame(alignment:.center)
                .border(.red)
            PokemonListView(viewModel: PokemonListViewModel())
        }
    }
}

struct PokemonRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
    }
}
