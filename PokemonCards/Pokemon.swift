//
//  Pokemon.swift
//  PokemonCards
//
//  Created by Erman Ufuk Demirci on 6.09.2022.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let stats: [Stats]
    let sprites: Sprites
}

struct Stats: Codable {
    let baseStat: Int
    let stat: Stat
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct Stat: Codable {
    let name: String
}

struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
