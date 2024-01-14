//
//  UserService.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import Foundation
import Combine

class UserService: IUserService {
    private var api: APIClient
    
    init(api: APIClient) {
        self.api = api
    }
    
    func getAll() -> AnyPublisher<[GithubUser], UserError> {
        let request = GetUsersRequest()
        return api.requestCollection(request)
            .map({ users in
                return users.map { GithubUser(id: $0.id, avatarUrl: $0.avatarUrl, userName: $0.login, fullName: $0.name ?? $0.login) }
            })
            .mapError({ error -> UserError in
                switch error {
                case .notFound:
                    return UserError.notFound
                case .tooManyRequest:
                    return UserError.tooManyRequest
                default:
                    return UserError.errorServer
                }
            })
            .eraseToAnyPublisher()
    }
}
