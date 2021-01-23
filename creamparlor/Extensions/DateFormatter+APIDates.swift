//
//  DateFormatter+APIDates.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation

extension DateFormatter {
    static let standard: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        return dateFormatter
    }()

    static let short: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}
