//
//  ListUserVM.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import Foundation
import Combine

final class ListUserVM: BaseVM {
    
    typealias C = AppCoordinator
    var coordinator: AppCoordinator!
    
    var showErrorSubject = PassthroughSubject<String, Never>()
    var showLoadingSubject = PassthroughSubject<Bool, Never>()
    private var cancelables = Set<AnyCancellable>()
    private var appendItemsSubject = PassthroughSubject<[UserViewModel], Never>()
    private let userSerivce: IUserService
    private var isFetching: Bool = false
    private var lastId: Int? = nil
    
    init(userSerivce: IUserService) {
        self.userSerivce = userSerivce
    }
    
    func transform(input: Input) -> Output {
        input.getUsers
            .sink {[weak self] _ in
                self?.fetchUsers()
            }
            .store(in: &cancelables)
        input.loadMore
            .sink {[weak self] _ in
                self?.fetchUsers()
            }
            .store(in: &cancelables)
        input.selectedUser
            .sink {[weak self] username in
                self?.coordinator.navigateToUserDetail(username)
            }
            .store(in: &cancelables)
        return Output(appendItems: appendItemsSubject.eraseToAnyPublisher(),
                      showError: showErrorSubject.eraseToAnyPublisher(),
                      showLoading: showLoadingSubject.eraseToAnyPublisher())
    }
    
    private func fetchUsers() {
        if isFetching == true {
            return
        }
        isFetching = true
        showLoadingSubject.send(true)
        self.userSerivce.getAll(since: lastId)
            .sink {[weak self] completion in
                if case .failure = completion {
                    self?.showLoadingSubject.send(false)
                    self?.showErrorSubject.send("Co Error")
                    self?.isFetching = false
                }
            } receiveValue: {[weak self] users in
                self?.isFetching = false
                self?.handleRespone(users)
            }
            .store(in: &cancelables)
    }
    
    private func handleRespone(_ users: [GithubUser]) {
        let items = users.map { UserViewModel(uid: $0.id, fullName: $0.fullName, userName: $0.userName, avatarURL: $0.avatarUrl)}
        lastId = users.last?.id
        appendItemsSubject.send(items)
        showLoadingSubject.send(false)
    }
}

extension ListUserVM {
    struct Input {
        let getUsers: AnyPublisher<Void, Never>
        let loadMore: AnyPublisher<Void, Never>
        let selectedUser: AnyPublisher<String, Never>
    }
    
    struct Output {
        let appendItems: AnyPublisher<[UserViewModel], Never>
        let showError: AnyPublisher<String, Never>
        let showLoading: AnyPublisher<Bool, Never>
    }
}
