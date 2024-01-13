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
    private func performRequest<R: Request>(_ request: R) -> AnyPublisher<Data, Error> {
        guard let urlRequest = request.asURLRequest(baseURL: env.baseURL, headerDefault: env.headerDefault) else {
            return Fail(outputType: Data.self, failure: APIError.badRequest).eraseToAnyPublisher()
        }

        return urlSession
            .dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.unknownError
                }
                if !(200...299).contains(response.statusCode) {
                    throw APIError(statusCode: response.statusCode)
                }
                return data
            }
            .eraseToAnyPublisher()
    }

    func request<R: Request>(_ request: R) -> AnyPublisher<R.Reps, APIError> {
        return performRequest(request)
            .decode(type: R.Reps.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                self.handleError(error)
            }
            .print()
            .eraseToAnyPublisher()
    }

    func requestCollection<R: Request>(_ request: R) -> AnyPublisher<[R.Reps], APIError> {
        return performRequest(request)
            .decode(type: [R.Reps].self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                self.handleError(error)
            }
            .print()
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
