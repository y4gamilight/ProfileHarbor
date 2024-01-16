//
//  ListUserViewModelTest.swift
//  ProfileHarborTests
//
//  Created by Lê Thành on 17/01/2024.
//

import XCTest
import Foundation
import Combine
@testable import ProfileHarbor

final class ListUserViewModelTest: XCTestCase {
    private var sut: ListUserVM!
    private var output: ListUserVM.Output!
    private var getUsersSubject = PassthroughSubject<Void, Never>()
    private var loadMoreSubject = PassthroughSubject<Void, Never>()
    private var selectedUserSubject = PassthroughSubject<String, Never>()
    private var cancelables = Set<AnyCancellable>()
    private var users: [UserViewModel] = []
    private var msgError: String = ""
    private var isLoading: Bool = false
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ListUserVM(userSerivce: MockUserService())
        let input = ListUserVM.Input(getUsers: getUsersSubject.eraseToAnyPublisher(), loadMore: loadMoreSubject.eraseToAnyPublisher(), selectedUser: selectedUserSubject.eraseToAnyPublisher())
        output = sut.transform(input: input)
        output.appendItems
            .sink { items in
                self.users.append(contentsOf: items)
            }
            .store(in: &cancelables)
        output.showError
            .sink { error in
                self.msgError = error
            }
            .store(in: &cancelables)
        output.showLoading
            .sink { isLoading in
                self.isLoading = isLoading
            }
            .store(in: &cancelables)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testGetAllUserSuccess() throws {
        let expectation = self.expectation(description: "test")
        getUsersSubject.send(())
        XCTAssertTrue(isLoading == true, "UI must be loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssert(self.users.count == 30, "Number of items is 30")
            XCTAssertTrue(self.isLoading == false , "UI must be stoping load UI")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        
    }
    
    func testGetAllUserFailureWhenCallTwoAPISameTime() throws {
        let expectation = self.expectation(description: "test")
        getUsersSubject.send(())
        loadMoreSubject.send(())
        XCTAssertTrue(isLoading == true, "UI must be loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssert(self.users.count == 30, "Number of items is 30, because loadMoreSubject won't excute")
            XCTAssertTrue(self.isLoading == false , "UI must be stoping load UI")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        
    }
    
    func testGetAllUserSuccessAndCorrectWhenLoadmore() throws {
        let expectation = self.expectation(description: "test")
        getUsersSubject.send(())
        XCTAssertTrue(isLoading == true, "UI must be loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertTrue(self.isLoading == false , "UI must be stoping load UI")
            self.loadMoreSubject.send(())
            XCTAssertTrue(self.isLoading == true, "UI must be loading")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            XCTAssert(self.users.count == 60, "Number of items is 60")
            XCTAssertTrue(self.isLoading == false , "UI must be stoping load UI")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        
    }
}
