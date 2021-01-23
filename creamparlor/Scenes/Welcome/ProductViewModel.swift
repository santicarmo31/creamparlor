//
//  ProductViewModel.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation

class ProductViewModel: Hashable {
    let product: Product
    var badgeCount: Int

    init(product: Product, badgeCount: Int) {
        self.product = product
        self.badgeCount = badgeCount
    }

    var hasBadgeCount: Bool {
        return badgeCount > 0
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(product)
    }

    static func ==(lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        return lhs.product.completeName == rhs.product.completeName
    }
}
