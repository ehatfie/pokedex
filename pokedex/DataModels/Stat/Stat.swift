//
//  Stat.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/14/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import Foundation
import PokemonAPI

class Stat {
    var id: Int
    var name: String
    var gameIndex: Int
    var isBattleOnly: Bool
    var affectingMoves: [String] = []
    var affectingNatures: [String] = []
    var characteristics: [String] = []
    var moveDamageClass: String
    
    init?(from pkmStat: PKMStat) {
        guard let id = pkmStat.id,
                let name = pkmStat.name,
                let gameIndex = pkmStat.gameIndex,
                let isBattleOnly = pkmStat.isBattleOnly,
                let moveDamage = pkmStat.moveDamageClass
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.gameIndex = gameIndex
        self.isBattleOnly = isBattleOnly
        self.moveDamageClass = ""
    }
    
    init() {
        self.id = -1
        self.name = ""
        self.gameIndex = -1
        self.isBattleOnly = false
        self.moveDamageClass = ""
    }
}
