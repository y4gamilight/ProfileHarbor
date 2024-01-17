//
//  UserServiceProtocol.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import Foundation
import Combine

public enum UserError: Error {
    case errorServer
    case tooManyRequest
    case noInternetNetwork
    case notFound
    
    var msgError: String {
        switch self {
        case .notFound:
            return StringKey.msgErrorUserInvalid
        case .tooManyRequest:
            return StringKey.msgErrorTooManyRequest
        case .errorServer:
            return StringKey.msgErrorServerTrouble
        case .noInternetNetwork:
            return StringKey.msgErrorInternetOffline
        }
    }
}

protocol IUserService {
    func getAll(since id: Int?) -> AnyPublisher<[GithubUser], UserError>
    func getDetailByUserName(_ username: String) -> AnyPublisher<GithubUser, UserError> 
}
