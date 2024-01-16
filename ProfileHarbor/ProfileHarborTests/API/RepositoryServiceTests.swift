//
//  RepositoryServiceTests.swift
//  ProfileHarborTests
//
//  Created by Lê Thành on 16/01/2024.
//

import XCTest
import Foundation
import Combine
@testable import ProfileHarbor

final class RepositoryServiceTests: XCTestCase {
    private var sut: IRepositoryService!
    private var cancelables: Set<AnyCancellable>!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = MockRepositoryService()
        cancelables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testGetAllRepositoriesSuccess() throws {
        sut.getAll(by: Constants.UserData.validUser, page: 1)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { repos in
                XCTAssert(repos.count == 30, "Number of items is 30")
            })
            .store(in: &cancelables)
    }
    
    func testGetRepositoriesWithInvalidUser() throws {
        sut.getAll(by: Constants.UserData.invalidUser, page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    XCTAssert(failure == .notFound)
                }
            }, receiveValue: { repos in
            })
            .store(in: &cancelables)
    }
    
    func testGetRepositoriesWithEmptyRepos() throws {
        sut.getAll(by: Constants.UserData.userWithEmpty, page: 1)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { repos in
                XCTAssert(repos.count == 0, "Number of items is 0")
            })
            .store(in: &cancelables)
    }
    
}
