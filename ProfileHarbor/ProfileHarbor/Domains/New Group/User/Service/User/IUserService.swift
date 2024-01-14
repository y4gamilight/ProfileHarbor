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
    case notFound
}

protocol IUserService {
    func getAll() -> AnyPublisher<[GithubUser], UserError>
}
