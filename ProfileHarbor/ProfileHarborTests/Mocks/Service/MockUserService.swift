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
        let path = Bundle(for: MockUserService.self).path(forResource: "mock_users", ofType: "json")
        
        guard let filePath = path,
              let dataFile = try? Data(contentsOf:  URL(filePath: filePath)) else {
            return Fail(error: UserError.errorServer)
                .eraseToAnyPublisher()
        }
        do {
            let items = try JSONDecoder().decode([GithubUserData].self, from: dataFile)
            return Just(items)
                .tryMap({ items in
                    return items.map { GithubUser(id: $0.id, avatarUrl: $0.avatarUrl, userName: $0.login, fullName: $0.name ?? $0.login)}
                })
                .mapError({ _ in UserError.errorServer })
                .eraseToAnyPublisher()
        } catch(let error) {
            debugPrint(error.localizedDescription)
            return Fail(error: UserError.errorServer)
                .eraseToAnyPublisher()
        }

    }
}
