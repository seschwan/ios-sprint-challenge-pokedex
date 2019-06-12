//
//  Pokeman.swift
//  PokeDex
//
//  Created by Seschwan on 5/31/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation

struct Pokemon: Codable, Equatable {
    let id: Int
    let name: String
    let abilities: [Abilities]
    let types: [Types]
    let sprites: Sprites
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
}

struct Abilities: Codable {
    var ability: Ability
}

struct Ability: Codable {
    var name: String
}

struct Types: Codable {
    var type: Type
}
struct Type: Codable {
    var name: String
}

struct Sprites: Codable {
    var front_default: String
}
