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
    private var updateItemsSubject = PassthroughSubject<[UserViewModel], Never>()
    private var showIllustrationSubject = PassthroughSubject<(Bool, CustomIllustrationView.Kind), Never>()
    private let userSerivce: IUserService
    private var isFetching: Bool = false
    private var lastId: Int? = nil
    
    init(userSerivce: IUserService) {
        self.userSerivce = userSerivce
    }
    
    func transform(input: Input) -> Output {
        input.getUsers
            .sink {[weak self] _ in
                self?.refreshList()
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
        return Output(updateItems: updateItemsSubject.eraseToAnyPublisher(),
                      appendItems: appendItemsSubject.eraseToAnyPublisher(),
                      showIllustration: showIllustrationSubject.eraseToAnyPublisher(),
                      showError: showErrorSubject.eraseToAnyPublisher(),
                      showLoading: showLoadingSubject.eraseToAnyPublisher())
    }
    private func refreshList() {
        isFetching = false
        lastId = nil
        fetchUsers()
    }
    
    private func fetchUsers() {
        if isFetching == true {
            return
        }
        isFetching = true
        showLoadingSubject.send(true)
        let lastId = self.lastId
        self.userSerivce.getAll(since: lastId)
            .sink {[weak self] completion in
                if case .failure(let error) = completion, lastId == self?.lastId {
                    if error == .noInternetNetwork {
                        self?.showIllustrationSubject.send((true, CustomIllustrationView.Kind.noNetwork))
                    } else {
                        self?.showIllustrationSubject.send((false, CustomIllustrationView.Kind.none))
                    }
                    self?.showErrorSubject.send(error.msgError)
                    self?.showLoadingSubject.send(false)
                    self?.isFetching = false
                }
            } receiveValue: {[weak self] users in
                if lastId != self?.lastId { return }
                self?.showIllustrationSubject.send((false, CustomIllustrationView.Kind.none))
                self?.isFetching = false
                self?.handleRespone(users)
            }
            .store(in: &cancelables)
    }
    
    private func handleRespone(_ users: [GithubUser]) {
        let items = users.map { UserViewModel(uid: $0.id, fullName: $0.fullName, userName: $0.userName, avatarURL: $0.avatarUrl)}
        if lastId != nil {
            appendItemsSubject.send(items)
        } else {
            updateItemsSubject.send(items)
        }
        lastId = users.last?.id
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
        let updateItems: AnyPublisher<[UserViewModel], Never>
        let appendItems: AnyPublisher<[UserViewModel], Never>
        let showIllustration: AnyPublisher<(Bool, CustomIllustrationView.Kind), Never>
        let showError: AnyPublisher<String, Never>
        let showLoading: AnyPublisher<Bool, Never>
    }
}
