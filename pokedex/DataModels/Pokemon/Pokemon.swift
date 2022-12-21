//
//  Pokemon.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/14/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import Foundation
import PokemonAPI

class Pokemon {
    var id: Int
    var name: String
    var baseExperience: Int
    var height: Int = 0
    var isDefault: Bool
    var order: Int
    var weight: Int = 0
    var abilities: [String] = [] // [PKMPokemonAbility]
    var forms: [String] = [] // [PKMPokemonForm]
    var gameIndices: [Int] = [] // [PKMVersionGameIndex]
    var heldItems: [String] = []// [PKMPokemonHeldItem]
    var moves: [String] = []// [PKMPokemonMove]
    var sprites: String = "" // PKMPokemonSprites
    var species: String = "" // PKMPokemonSpecies
    var stats: [PokemonStat] // [PKMPokemonStat]
    var types: [String] // [PKMPokemonType]
    
    init?(from pkmPokemon: PKMPokemon) {
        guard let id = pkmPokemon.id,
              let name = pkmPokemon.name,
              let baseExperience = pkmPokemon.baseExperience,
              let height = pkmPokemon.height,
              let isDefault = pkmPokemon.isDefault,
              let order = pkmPokemon.order,
              let stats = pkmPokemon.stats,
              let types = pkmPokemon.types
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.baseExperience = baseExperience
        self.height = height
        self.isDefault = isDefault
        self.order = order
        self.stats = stats.flatMap({ PokemonStat(from: $0 ) })
        self.types = []
    }
}



class PokemonStat {
    var stat: Stat
    var effort: Int
    var baseStat: Int
    
    init?(from pkmPokemonStat: PKMPokemonStat) {
        guard let stat = pkmPokemonStat.stat,
              let effort = pkmPokemonStat.effort,
              let baseStat = pkmPokemonStat.baseStat
        else {
            return nil
        }
        self.stat = Stat()
        self.effort = effort
        self.baseStat = baseStat
        
        PokemonAPI().resourceService.fetch(stat) { [weak self] result in
            if let result = try? result.get(),
               let stat = Stat(from: result)
            {
                self?.stat = stat
            }
        }
    }
}

class TypeRelations {
    var noDamageTo: [PKType] = []
    var halfDamageTo: [PKType] = []
    var doubleDamageTo: [PKType] = []
    var noDamageFrom: [PKType] = []
    var halfDamageFrom: [PKType] = []
    var doubleDamageFrom: [PKType] = []
    
    init(from typeRelations: PKMTypeRelations) {
        
    }
    
    init() { }
}

class GenerationGameIndex {
    var gameIndex: Int
    var generation: Generation
    
    init?(from data: PKMGenerationGameIndex) {
        guard let gameIndex = data.gameIndex,
              let generation = data.generation
        else { return nil }
        
        self.gameIndex = gameIndex
        self.generation = Generation()
        
        PokemonAPI().resourceService.fetch(generation) { [weak self] result in
            if let result = try? result.get(),
               let generation = Generation(from: result) {
                self?.generation = generation
            }
        }
    }
}

class Generation {
    var id: Int
    var name: String
    var abilities: [String] = [] // [PKMAbility]
    var mainRegion: String = "" // PKMRegion
    var moves: [String] = [] // [PKMMove]
    var pokemonSpecies: [String] = [] // [PKMPokemonSpecies]
    var types: [PKType]
    var versionGroups: String = "" // [PKMVersionGroup]
    
    init?(from generation: PKMGeneration) {
        guard let id = generation.id,
              let name = generation.name,
              let types = generation.types
        else { return nil }
        
        self.id = id
        self.name = name
        self.types = []
    }
    
    init() {
        self.id = -1
        self.name = ""
        self.types = []
    }
}

class PKType {
    var id: Int
    var name: String
    var damageRelations: TypeRelations
    var gameindices: [String] = [] // [PKMGenerationGameIndex]
    var generation: Generation // PKMGeneration
    var moveDamageClass: String // MoveDamageClass
    var pokemon: String = "" // [PKMTypePokemon]
    var moves: [String] = [] // [PKMMove]
    
    init?(from type: PKMType) {
        guard let id = type.id,
              let name = type.name,
              let damageRelations = type.damageRelations,
              let gameIndices = type.gameIndices,
              let generation = type.generation
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.damageRelations = TypeRelations(from: damageRelations)
        self.generation = Generation()
        self.moveDamageClass = ""
        
        PokemonAPI().resourceService.fetch(generation) { [weak self] result in
            if let result = try? result.get(),
               let generation = Generation(from: result)
            {
                self?.generation = generation
            }
        }
    }
    
    init() {
        self.id = -1
        self.name = ""
        self.damageRelations = TypeRelations()
        self.generation = Generation()
        self.moveDamageClass = ""
    }
}

class PokemonType {
    var slot: Int
    var type: String
    
    init?(from pkmType: PKMPokemonType) {
        self.slot = 0
        self.type = ""
    }
}
