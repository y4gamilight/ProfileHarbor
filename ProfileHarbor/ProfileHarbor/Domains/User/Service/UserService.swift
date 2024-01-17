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
    
    func getAll(since id: Int?) -> AnyPublisher<[GithubUser], UserError> {
        let request = GetUsersRequest(sinceId: id)
        return api.requestCollection(request)
            .map({ users in
                return users.map { GithubUser(id: $0.id, avatarUrl: $0.avatarUrl, userName: $0.login, fullName: $0.name ?? $0.login, following: $0.following ?? 0, followers: $0.followers ?? 0) }
            })
            .mapError({ error -> UserError in
                switch error {
                case .notFound:
                    return UserError.notFound
                case .tooManyRequest:
                    return UserError.tooManyRequest
                case .noInternetNetwork:
                    return UserError.noInternetNetwork
                default:
                    return UserError.errorServer
                }
            })
            .eraseToAnyPublisher()
    }
    
    func getDetailByUserName(_ username: String) -> AnyPublisher<GithubUser, UserError> {
        let request = GetUserRequest(username: username)
        return api.request(request)
            .map({ user in
                return GithubUser(id: user.id, avatarUrl: user.avatarUrl, userName: user.login, fullName: user.name ?? user.login, following: user.following ?? 0, followers: user.followers ?? 0)
            })
            .mapError({ error -> UserError in
                switch error {
                case .notFound:
                    return UserError.notFound
                case .tooManyRequest:
                    return UserError.tooManyRequest
                case .noInternetNetwork:
                    return UserError.noInternetNetwork
                default:
                    return UserError.errorServer
                }
            })
            .eraseToAnyPublisher()
    }
}
