//
//  Endpoint.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation

enum HTTPMethod: String {
    case get, post, put
}

struct Endpoint<Response> {
    let baseURL: String
    let path: String
    let params: [String: Any]
    let method: HTTPMethod
    let query: [String: String]?
    let headers: [String: String]
    let decoder: JSONDecoder

    init(_ baseURL: String, path: String = "", params: [String: Any] = [:], method: HTTPMethod = .get, headers: [String: String] = [:], query: [String: String] = [:], decoder: JSONDecoder = .dateDecoder) {
        self.baseURL = baseURL
        self.path = path
        self.params = params
        self.query = query
        self.method = method
        self.headers = headers
        self.decoder = decoder
    }

    func urlRequest() -> URLRequest? {
        guard let url = getURL() else { return nil }

        var request = URLRequest(url: url)
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpMethod = method.rawValue
        if method == .post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted])
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        return request
    }
}

private extension Endpoint {
    func getURL() -> URL? {
        var url = URLComponents(string: baseURL)

        if !path.isEmpty {
            url?.path = path
        }

        if query != [:] {
            url?.queryItems = query.map { $0.map { URLQueryItem(name: $0.key, value: $0.value) } }
        }

        return url?.url
    }
}
