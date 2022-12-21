//
//  DataFetcher.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/18/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import Foundation

import PokemonAPI
import Combine

class DataFetcher {
    
    
    static func fetchPokedexData(pageLimit: Int = 5) async throws -> PKMPagedObject<PKMPokedex> {
        return try await PokemonAPI().gameService.fetchPokedexList(paginationState: .initial(pageLimit: pageLimit))
    }
}
