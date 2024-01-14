//
//  UserDetailVM.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import Foundation
import Combine

class UserDetailVM: BaseVM {
    var showErrorSubject = PassthroughSubject<String, Never>()
    var showLoadingSubject = PassthroughSubject<Bool, Never>()
    private var reloadDataSubject = PassthroughSubject<(UserInfoCellModel, [RepositoryCellModel]), Never>()
    private var cancelables = Set<AnyCancellable>()
    
    var coordinator: AppCoordinator!
    private var userService: IUserService
    private var username: String
    init(username: String, userService: IUserService) {
        self.username = username
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        input.getDetail
            .sink {[weak self] in
                self?.fetchDetail()
            }
            .store(in: &cancelables)
        return Output(reloadData: reloadDataSubject.eraseToAnyPublisher(), showError: showErrorSubject.eraseToAnyPublisher(), showLoading: showLoadingSubject.eraseToAnyPublisher())
    }
    
    
    private func fetchDetail() {
        showLoadingSubject.send(true)
        userService.getDetailByUserName(username)
            .sink {[weak self] completion in
                if case .failure = completion {
                    self?.showLoadingSubject.send(false)
                }
            } receiveValue: {[weak self] user in
                let userInfo = UserInfoCellModel(avatarUrl: user.avatarUrl, fullName: user.fullName, userName: user.userName, numOfFollowings: 0, numOfFollowers: 0, isLoading: true)
                self?.showLoadingSubject.send(false)
                self?.reloadDataSubject.send((userInfo, []))
            }
            .store(in: &cancelables)

    }
}

extension UserDetailVM {
    
    struct Input {
        let getDetail: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reloadData: AnyPublisher<(UserInfoCellModel, [RepositoryCellModel]), Never>
        let showError: AnyPublisher<String, Never>
        let showLoading: AnyPublisher<Bool, Never>
    }
    typealias C = AppCoordinator
}
