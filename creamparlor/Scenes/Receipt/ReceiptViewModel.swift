//
//  ReceiptViewModel.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation

struct ReceiptViewModel {

    let currencyFormatter: NumberFormatter = .currencyFormatter
    let items: [ProductViewModel]

    init(items: [ProductViewModel]) {
        self.items = items
    }

    var totalPrice: String {
        let total = items.reduce(0, { $0 + $1.totalPrice })
        return currencyFormatter.string(from: NSNumber(value: total)) ?? ""
    }

    func nameWithPrice(for item: ProductViewModel) -> String {
        return "\(item.product.completeName)(\(item.badgeCount))"
    }

    func price(for item: ProductViewModel) -> String {
        return currencyFormatter.string(from: NSNumber(value: item.totalPrice)) ?? ""
    }
}

fileprivate extension ProductViewModel {
    var totalPrice: Double {
        guard let price = NumberFormatter.currencyFormatter.number(from: product.price) else {
            return 0.0
        }
        return Double(badgeCount) * Double(truncating: price)
    }
}
