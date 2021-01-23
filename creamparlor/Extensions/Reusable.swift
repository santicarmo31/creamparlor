//
//  Reusable.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation
protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
