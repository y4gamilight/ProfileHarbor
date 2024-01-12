//
//  APIError.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 12/01/2024.
//

import Foundation

public enum APIError: LocalizedError, Equatable {
    case invalidRequest
    case badRequest //400
    case unauthorized // 401
    case forbidden // 403
    case notFound // 404
    case notAcceptable // 406
    case gone // 410
    case tooManyRequest // 429
    case serverError // 500
    case serverUnavailable // 503
    case badGateway // 502
    case gatewayTimeout // 504
    case error4xx(_ code: Int)
    case error5xx(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
    
    init(statusCode: Int) {
        switch statusCode {
        case APIStatusCode.badRequest.rawValue:
            self = .badRequest
        case APIStatusCode.unauthorized.rawValue:
            self = .unauthorized
        case APIStatusCode.forbidden.rawValue:
            self = .forbidden
        case APIStatusCode.notFound.rawValue:
            self = .notFound
        case APIStatusCode.notAcceptable.rawValue:
            self = .notAcceptable
        case APIStatusCode.gone.rawValue:
            self = .gone
        case APIStatusCode.tooManyRequest.rawValue:
            self = .tooManyRequest
        case APIStatusCode.serverError.rawValue:
            self = .serverError
        case APIStatusCode.badGateway.rawValue:
            self = .badGateway
        case APIStatusCode.serverUnavailable.rawValue:
            self = .serverUnavailable
        case APIStatusCode.gatewayTimeout.rawValue:
            self = .gatewayTimeout
        default:
            if statusCode < 500 && statusCode >= 400 {
                self = .error4xx(statusCode)
            } else if statusCode < 600 && statusCode >= 500 {
                self = .error5xx(statusCode)
            } else {
                self = .unknownError
            }
        }
    }
}


public enum APIStatusCode: Int {
    case methodGetSuccess = 200
    case methodPostOrPutSuccess = 201
    case methodDeleteSuccess = 204
    case accepted = 202
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case notAcceptable = 406
    case gone = 410
    case tooManyRequest = 429
    case serverError = 500
    case badGateway = 502
    case serverUnavailable = 503
    case gatewayTimeout = 504
}
