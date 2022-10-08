//
//  Network.swift
//  GithubUserSearch
//
//

import Foundation
import Combine
import UIKit

///// Defines the Network service errors.
enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case responseError(statusCode: Int)
    case jsonDecodingError(error: Error)
}

final class NetworkService {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        guard let request = resource.urlRequest else {
            return .fail(NetworkError.invalidRequest)
        }
        
        return session
            .dataTaskPublisher(for: request) // URLSession.DataTaskPublisher 타입 반환
                                            // URLSession.DataTaskPublisher = A publisher that delivers the results of performing URL session data tasks.
            .tryMap { result -> Data in
                // tryMap -> Transforms all elements from the upstream publisher with a provided error-throwing closure.
                guard let response = result.response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode)
                else {
                    let response = result.response as? HTTPURLResponse
                    let statusCode = response?.statusCode ?? -1
                    throw NetworkError.responseError(statusCode: statusCode)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
