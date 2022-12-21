//
//  Attribute.swift
//  pokedex
//
//  Created by Erik Hatfield on 6/24/20.
//  Copyright © 2020 Erik Hatfield. All rights reserved.
//

import Foundation

struct DecodedStat: Decodable {
    let baseStat: Int
    let effort: Int
    //let name: String
    // let url: String
    
    
    
    enum CodingKeys: CodingKey {
        case baseStat
        case effort
       
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseStat = try container.decode(Int.self, forKey: CodingKeys.baseStat)
        self.effort = try container.decode(Int.self, forKey: CodingKeys.effort)
    }
}

struct DecodedArray: Decodable {
    var array: [DecodedStat]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempArray = [DecodedStat]()
        
        for key in container.allKeys {
            let decodedObject = try container.decode(DecodedStat.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        self.array = tempArray
    }
}


