//
//  NumberFormatter+Currency.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumSignificantDigits = 2
        return formatter
    }()
}
