//
//  UserDefaultsHelper.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/18/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import Foundation


class UserDefaultsHelper {
    var testKey = "PokedexData"

    
    static func saveData(data: Data, key: String) {
        let defaults = UserDefaults.standard
        
        defaults.set(data, forKey: key)
    }
    
    static func getData(for key: String) -> Data? {
        let defaults = UserDefaults.standard
        
        let foo = defaults.data(forKey: key)
        
        return foo
    }
}
