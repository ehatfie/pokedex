//
//  BaseStats.swift
//  pokedex
//
//  Created by Erik Hatfield on 6/25/20.
//  Copyright © 2020 Erik Hatfield. All rights reserved.
//

import Foundation

struct StatStruct {
    let name: String
    let baseValue: Int
    let effort: Int
    let url: String
    
    init(statOuter: StatOuter) {
        self.name = statOuter.statInner.name
        self.baseValue = Int(statOuter.baseStat)
        self.effort = Int(statOuter.effort)
        self.url = statOuter.statInner.url
    }
}

struct BaseStats {
    let stats: [Stat]
    
    init(with stats: [Stat]) {
        self.stats = stats
    }
}

struct StatInner {
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.name = name;
        self.url = url;
    }
}

struct StatOuter {
    let baseStat: Int64
    let effort: Int64
    let statInner: StatInner
    
    init(baseStat: Int64, effort: Int64, statInner: StatInner) {
        self.baseStat = baseStat
        self.effort = effort
        self.statInner = statInner
    }
}
