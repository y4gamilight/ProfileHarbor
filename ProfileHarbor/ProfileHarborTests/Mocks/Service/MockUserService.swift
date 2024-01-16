//
//  MockUserService.swift
//  ProfileHarborTests
//
//  Created by Lê Thành on 13/01/2024.
//

import Foundation
import Combine
@testable import ProfileHarbor

class MockUserService: IUserService {
    func getAll(since id: Int?) -> AnyPublisher<[GithubUser], UserError> {
        let source = id == Constants.UserData.idWithEmptyData ? "mock_empty_array" : "mock_users"
        let path = Bundle(for: MockUserService.self).path(forResource: source, ofType: "json")
        
        guard let filePath = path,
              let dataFile = try? Data(contentsOf:  URL(filePath: filePath)) else {
            return Fail(error: UserError.errorServer)
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        do {
            let items = try JSONDecoder().decode([GithubUserData].self, from: dataFile)
            return Just(items)
                .tryMap({ items in
                    return items.map { GithubUser(id: $0.id, avatarUrl: $0.avatarUrl, userName: $0.login, fullName: $0.name ?? $0.login ,following: $0.following ?? 0, followers: $0.followers ?? 0)}
                })
                .delay(for: 1.0, scheduler: RunLoop.main)
                .mapError({ _ in UserError.errorServer })
                .eraseToAnyPublisher()
        } catch(let error) {
            debugPrint(error.localizedDescription)
            return Fail(error: UserError.errorServer)
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
    
    func getDetailByUserName(_ username: String) -> AnyPublisher<GithubUser, UserError> {
        guard username == Constants.UserData.validUser else {
            return Fail(error: UserError.notFound)
                .delay(for: 1.0, scheduler: RunLoop.main)
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
                .delay(for: 1.0, scheduler: RunLoop.main)
                .mapError({ _ in UserError.errorServer })
                .eraseToAnyPublisher()
        } catch(let error) {
            debugPrint(error.localizedDescription)
            return Fail(error: UserError.errorServer)
                .delay(for: 1.0, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
}
