//
//  JsonDecoder+APIDates.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation

extension JSONDecoder {
    static var dateDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let formats: [DateFormatter] = [.standard, .short]
            for format in formats {
                if let date = format.date(from: dateString) {
                    return date
                }
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })
        return jsonDecoder
    }
}
