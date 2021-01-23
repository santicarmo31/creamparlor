//
//  Product.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation

struct Product: Codable {
    let name1: String
    let name2: String
    let price: String
    let bg_color: String
    let type: String
}

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name1)
        hasher.combine(name2)
    }    
}

extension Product {
    var completeName: String {
        return "\(name1) \(name2)"
    }
}
