//
//  RepositoryService.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 16/01/2024.
//

import Foundation
import Combine

class RepositoryService: IRepositoryService {
    private let api: APIClient
    
    init(api: APIClient) {
        self.api = api
    }
    
    func getAll(by username: String) -> AnyPublisher<[GitHubRepository], RepositoryError> {
        let request = GetRepositoriesRequest(username: username)
        return api.requestCollection(request)
            .map({ repos in
                return repos.map { GitHubRepository(id: $0.id, nodeID: $0.nodeID, name: $0.name, fullName: $0.fullName, isPrivate: $0.isPrivate, url: $0.url, forksURL: $0.forksURL, language: $0.language, isFork: $0.isFork) }
            })
            .mapError({ error -> RepositoryError in
                switch error {
                case .notFound:
                    return RepositoryError.notFound
                case .tooManyRequest:
                    return RepositoryError.tooManyRequest
                default:
                    return RepositoryError.errorServer
                }
            })
            .eraseToAnyPublisher()
    }
}
