//
//  NetworkError.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation
enum NetworkError: Error, LocalizedError {
    case malformedURLRequest
    case invalidStatusCode(String)

    var errorDescription: String? {
        switch self {
        case .malformedURLRequest:
            return "Request is malformed"
        case .invalidStatusCode(let message):
            return message
        }
    }
}
