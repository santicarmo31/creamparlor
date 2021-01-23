//
//  NetworkClient.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import Foundation
import Combine

protocol APINetworkClient {
    func executeRequest<Response: Codable>(_ endpoint: Endpoint<Response>, completion: @escaping((Result<Response, Error>) -> Void))
}

final class NetworkClient: APINetworkClient {
    struct Dependencies {
        var session: URLSession = .shared
    }

    private let requestsInProcessQueue = DispatchQueue(label: "requestsInProcess")
    private var requestsInProcess: [Int: AnyCancellable] = [:]
    var dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func executeRequest<Response: Codable>(_ endpoint: Endpoint<Response>, completion: @escaping((Result<Response, Error>) -> Void)) {
        guard let urlRequest = endpoint.urlRequest() else {
            completion(.failure(NetworkError.malformedURLRequest))
            return
        }

        let id = urlRequest.hashValue
        let request = dependencies.session.dataTaskPublisher(for: urlRequest)
            .tryMap {
                guard $0.1.hasSuccessStatusCode else {
                    throw self.handleTaskError(data: $0.0, response: $0.1)
                }

                return $0.0
            }
            .decode(type: Response.self, decoder: endpoint.decoder)
            .sink { [weak self] (sinkCompletion) in
                if case .failure(let error) = sinkCompletion {
                    completion(.failure(error))
                }
                self?.requestsInProcessQueue.async(flags: .barrier) {
                    self?.requestsInProcess.removeValue(forKey: id)
                }
            } receiveValue: { (data) in
                completion(.success(data))
            }

        requestsInProcess[id] = request
    }

    private func handleTaskError(data: Data, response: URLResponse) -> Error {
        return NetworkError.invalidStatusCode(
            """
            Bad Request
            Status code: \(response.httpStatusCode)
            """
        )
    }
}

private extension URLResponse {
    var httpStatusCode: Int {
        (self as? HTTPURLResponse)?.statusCode ?? 418
    }

    var hasSuccessStatusCode: Bool {
        (200 ..< 300) ~= httpStatusCode
    }
}
