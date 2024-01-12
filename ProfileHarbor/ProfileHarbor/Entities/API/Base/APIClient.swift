//
//  APIClient.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 12/01/2024.
//

import Foundation
import Combine

struct APIClient {
    var env: APIEnvironment
    var urlSession: URLSession
    init(env: APIEnvironment = .dev, urlSession: URLSession = .shared) {
        self.env = env
        self.urlSession = urlSession
    }
    
    /// Dispatches a Request and returns a publisher
    /// - Parameter request: Request to Dispatch
    /// - Returns: A publisher containing decoded data or an error
    func request<R: Request>(_ request: R) -> AnyPublisher<R.Reps, APIError> {
        guard let urlRequest = request.asURLRequest(baseURL: env.baseURL, headerDefault: env.headerDefault) else {
            return Fail(outputType: R.Reps.self, failure: APIError.badRequest).eraseToAnyPublisher()
        }
        return urlSession
            .dataTaskPublisher(for: urlRequest)
        // Map on Request response
            .tryMap({ data, response in
                // If the response is invalid, throw an error
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.unknownError
                }
                if !(200...299).contains(response.statusCode) {
                    throw APIError(statusCode: response.statusCode)
                }
                return data
            })
        // Decode data using our ReturnType
            .decode(type: R.Reps.self, decoder: JSONDecoder())
        // Handle any decoding errors
            .mapError { error in
                return self.handleError(error)
            }
            .print()
        // And finally, expose our publisher
            .eraseToAnyPublisher()
    }
}


extension APIClient {
    fileprivate func handleError(_ error: Error) -> APIError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as APIError:
            return error
        default:
            return .unknownError
        }
    }
}
