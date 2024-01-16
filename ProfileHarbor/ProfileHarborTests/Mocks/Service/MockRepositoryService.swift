//
//  MockRepositoryService.swift
//  ProfileHarborTests
//
//  Created by Lê Thành on 16/01/2024.
//

import Foundation
import Combine
@testable import ProfileHarbor

class MockRepositoryService: IRepositoryService {
    func getAll(by username: String, page: Int) -> AnyPublisher<[GitHubRepository], RepositoryError> {
        guard username == Constants.UserData.validUser else {
            return  Fail(error: RepositoryError.notFound)
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        let source = username == Constants.UserData.userWithEmpty ? "mock_empty_array" : "mock_repositories"
        let path = Bundle(for: MockRepositoryService.self).path(forResource: source, ofType: "json")
        
        guard let filePath = path,
              let dataFile = try? Data(contentsOf:  URL(filePath: filePath)) else {
            return Fail(error: RepositoryError.errorServer)
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        do {
            let items = try JSONDecoder().decode([GitHubRepositoryData].self, from: dataFile)
            return Just(items)
                .tryMap({ items in
                    return items.map { GitHubRepository(id: $0.id, nodeID: $0.nodeID, name: $0.name, fullName: $0.fullName, isPrivate: $0.isPrivate, url: $0.htmlURL, forksURL: $0.forksURL, language: $0.language, isFork: $0.isFork, starCount: $0.starCount) }
                })
                .mapError({ _ in RepositoryError.errorServer })
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } catch(let error) {
            debugPrint(error.localizedDescription)
            return Fail(error: RepositoryError.errorServer)
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
    
    func getDetailByUserName(_ username: String) -> AnyPublisher<GithubUser, UserError> {
        guard username == Constants.UserData.invalidUser else {
            return Fail(error: UserError.notFound)
                .eraseToAnyPublisher()
        }
        let path = Bundle(for: MockUserService.self).path(forResource: "mock_user", ofType: "json")
        
        guard let filePath = path,
              let dataFile = try? Data(contentsOf:  URL(filePath: filePath)) else {
            return Fail(error: UserError.errorServer)
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        do {
            let items = try JSONDecoder().decode(GithubUserData.self, from: dataFile)
            return Just(items)
                .tryMap({ user in
                    return GithubUser(id: user.id, avatarUrl: user.avatarUrl, userName: user.login, fullName: user.name ?? user.login ,following: user.following ?? 0, followers: user.followers ?? 0)
                })
                .mapError({ _ in UserError.errorServer })
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } catch(let error) {
            debugPrint(error.localizedDescription)
            return Fail(error: UserError.errorServer)
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
}
