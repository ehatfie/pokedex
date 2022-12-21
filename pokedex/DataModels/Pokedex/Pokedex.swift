//
//  Pokedex.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/14/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import Foundation
import PokemonAPI

class Pokedex {
    var id: Int = 0
    var name: String = ""
    var pokemonEntries: [PokemonEntry] = []
    var region: String = ""
    
    init?(from data: PKMPokedex) {
        guard let id = data.id,
              let name = data.name,
              let pokemonEntries = data.pokemonEntries,
              let region = data.region
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.pokemonEntries = pokemonEntries.compactMap { PokemonEntry(from: $0 )}
        self.region = ""
    }
}

class PokemonEntry {
    var entryNumber: Int
    var pokemonSpecies: PokemonSpecies
    
    init?(from data: PKMPokemonEntry) {
        guard let entryNumber = data.entryNumber,
              let pokemonSpecies = data.pokemonSpecies
        else { return nil }
        
        self.entryNumber = entryNumber
        self.pokemonSpecies = PokemonSpecies()
        
        PokemonAPI().resourceService.fetch(pokemonSpecies) { [weak self] result in
            if let result = try? result.get(),
               let pokemonSpecies = PokemonSpecies(from: result)
            {
                self?.pokemonSpecies = pokemonSpecies
            }
        }
    }
    
    init?(from data: PKMPokemonEntry) async throws {
        guard let entryNumber = data.entryNumber,
              let pokemonSpecies = data.pokemonSpecies
        else { return nil }
        
        self.entryNumber = entryNumber
        self.pokemonSpecies = PokemonSpecies()
        
        let pkmPokemonSpecies = try await PokemonAPI().resourceService.fetch(pokemonSpecies)
        guard let pokemonSpecies = PokemonSpecies(from: pkmPokemonSpecies) else {
            print("couldnt create PokemonSpecies for \(pokemonSpecies.name ?? "NO NAME")")
            return nil
        }
        
        self.pokemonSpecies = pokemonSpecies
    }
    
    init() {
        self.entryNumber = 0
        self.pokemonSpecies = PokemonSpecies()
    }
}

class PokemonSpecies {
    var id: Int
    var name: String
    var order: Int
    var genderRate: Int
    var captureRate: Int
    var baseHappiness: Int
    var isBaby: Bool
    var hatchCounter: Int
    var hasGenderDifferences: Bool
    var formSwitchable: Bool
    var growthRate: String = "" // PKMGrowthRate
    var pokedexNumbers: [String] // [PKMPokemonSpeciesDexEntry]
    var eggGroups: [String] = [] // [PKMPokemonEggGroup]
    var color: String = "" // PKMPokemonColor
    var shape: String = "" // PKMPokemonSpace
    var evolveFromSpecies: PokemonSpecies?
    var evolutionChain: String // PKMEvolutionChaing
    var habitat: String // PKMPokemonHabitat
    var generation: Generation
    var varieties: [String] = [] //[PKMPokemonSpeciesVariety]
    
    init() {
        self.id = -1
        self.name = ""
        self.order = -1
        self.genderRate = -1
        self.captureRate = -1
        self.baseHappiness = -1
        self.isBaby = false
        self.hatchCounter = 0
        self.hasGenderDifferences = false
        self.formSwitchable = false
        self.pokedexNumbers = []
        self.evolveFromSpecies = nil
        self.evolutionChain = ""
        self.habitat = ""
        self.generation = Generation()
    }
    
    init?(from data: PKMPokemonSpecies) {
        guard let id = data.id,
              let name = data.name,
              let order = data.order,
              let genderRate = data.genderRate,
              let captureRate = data.captureRate,
              let baseHappiness = data.baseHappiness,
              let isBaby = data.isBaby,
              let hatchCounter = data.hatchCounter,
              let hasGenderDifferences = data.hasGenderDifferences,
              let formSwitchable = data.formsSwitchable,
              let habitat = data.habitat,
              let generation = data.generation,
              let varieties = data.varieties
        else { return nil }
        // data.evolveFromSpecies
        // data.evolutionChain
        self.id = id
        self.name = name
        self.order = order
        self.genderRate = genderRate
        self.captureRate = captureRate
        self.baseHappiness =  baseHappiness
        self.isBaby = isBaby
        self.hatchCounter = hatchCounter
        self.hasGenderDifferences = hasGenderDifferences
        self.formSwitchable = formSwitchable
        self.habitat = ""
        
        self.generation = Generation()
        self.pokedexNumbers = []
        self.evolveFromSpecies = nil
        self.evolutionChain = ""
        
        PokemonAPI().resourceService.fetch(generation) { [weak self] result in
            if let result = try? result.get(),
               let generation = Generation(from: result)
            {
                self?.generation = generation
            }
        }
        
        if let evolveFromSpecies = data.evolvesFromSpecies {
            PokemonAPI().resourceService
                .fetch(evolveFromSpecies) { [weak self] result in
                if let result = try? result.get(),
                   let species = PokemonSpecies(from: result) {
                    self?.evolveFromSpecies = species
                }
            }
        }
    }
}
