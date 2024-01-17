//
//  UserDetailViewModelTest.swift
//  ProfileHarborTests
//
//  Created by Lê Thành on 17/01/2024.
//

import XCTest
import Foundation
import Combine
@testable import ProfileHarbor

final class UserDetailViewModelTest: XCTestCase {
    private var sut: UserDetailVM!
    private var output: UserDetailVM.Output!
    private var getDetailSubject = PassthroughSubject<Void, Never>()
    private var openRepoWebSubject = PassthroughSubject<URL?, Never>()
    private var cancelables = Set<AnyCancellable>()
    private var msgError: String = ""
    private var isLoading: Bool = false
    private var userInfo: UserInfoCellModel?
    private var repos: [RepositoryCellModel] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UserDetailVM(username: Constants.UserData.validUser, userService: MockUserService(), repoService: MockRepositoryService())
        setupListener()
    }
    
    private func setupListener() {
        let input = UserDetailVM.Input(getDetail: getDetailSubject.eraseToAnyPublisher(), openWebView: openRepoWebSubject.eraseToAnyPublisher())
        output = sut.transform(input: input)
        output.reloadUserSection
            .sink { user in
                self.userInfo = user
            }
            .store(in: &cancelables)
        output.reloadReposSection
            .sink { repos in
                self.repos = repos
            }
            .store(in: &cancelables)
        output.showLoading
            .sink { isLoading in
                self.isLoading = isLoading
            }
            .store(in: &cancelables)
        output.showError
            .sink { msgError in
                self.msgError = msgError
            }
            .store(in: &cancelables)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testGetDetailDataSuccess() throws {
        let expectation = self.expectation(description: "test")
        getDetailSubject.send(())
        XCTAssertTrue(isLoading == true, "UI must be loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertNotNil(self.userInfo, "Data must be not nil")
            XCTAssertTrue(self.repos.count > 0 , "List repo isn't empty")
            XCTAssertTrue(self.isLoading == false, "UI must be loading")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        
    }
    
    func testGetDetailDataSuccessButRepoIsEmpty() throws {
        let expectation = self.expectation(description: "test")
        sut.username = Constants.UserData.userWithEmpty
        getDetailSubject.send(())
        XCTAssertTrue(isLoading == true, "UI must be loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertNotNil(self.userInfo, "Data must be not nil")
            XCTAssertTrue(self.repos.count == 0 , "List repo is empty")
            XCTAssertTrue(self.isLoading == false, "UI must be loading")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        
    }
    
    func testGetDetailDataFailureWithInvalidUser() throws {
        let expectation = self.expectation(description: "test")
        sut.username = Constants.UserData.invalidUser
        getDetailSubject.send(())
        XCTAssertTrue(isLoading == true, "UI must be loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertNil(self.userInfo, "Data must be not nil")
            XCTAssertTrue(self.repos.count == 0 , "List repo is empty")
            XCTAssertTrue(self.msgError.isEmpty == false, "Message error has data")
            XCTAssertTrue(self.isLoading == false, "UI must be loading")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        
    }
}
