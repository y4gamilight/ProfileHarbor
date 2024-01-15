//
//  IRepositoryService.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 16/01/2024.
//

import Foundation
import Combine

public enum RepositoryError: Error {
    case errorServer
    case tooManyRequest
    case notFound
}

protocol IRepositoryService {
    func getAll(by username: String) -> AnyPublisher<[GitHubRepository], RepositoryError>
}
