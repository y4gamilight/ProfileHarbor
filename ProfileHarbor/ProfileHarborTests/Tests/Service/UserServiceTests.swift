//
//  UserServiceTests.swift
//  ProfileHarborTests
//
//  Created by Lê Thành on 13/01/2024.
//
import XCTest
import Foundation
import Combine
@testable import ProfileHarbor

final class UserServiceTests: XCTestCase {
    private var sut: IUserService!
    private var cancelables: Set<AnyCancellable>!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = MockUserService()
        cancelables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testGetAllUserSuccess() throws {
        let expectation = self.expectation(description: "test")
        sut.getAll(since: nil)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { users in
                XCTAssert(users.count == 30, "Number of items is 30")
                expectation.fulfill()
            })
            .store(in: &cancelables)
        waitForExpectations(timeout: 5.0)
    }
    
    func testGetUserDetail() throws {
        let expectation = self.expectation(description: "test")
        sut.getDetailByUserName(Constants.UserData.validUser)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    debugPrint("Finished")
                case .failure(let error):
                    debugPrint("\(error)")
                }
            }, receiveValue: { users in
                XCTAssert(users.userName == Constants.UserData.validUser)
                expectation.fulfill()
            })
            .store(in: &cancelables)
        waitForExpectations(timeout: 5.0)
    }
    
    func testGetUserDetailByInvalidId() throws {
        let expectation = self.expectation(description: "test")
        sut.getDetailByUserName(Constants.UserData.invalidUser)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    XCTAssert(failure == .notFound)
                    expectation.fulfill()
                }
            }, receiveValue: { users in
            })
            .store(in: &cancelables)
        waitForExpectations(timeout: 5.0)
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
