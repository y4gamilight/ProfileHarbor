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
    private var reloadListSubject = PassthroughSubject<[UserViewModel], Never>()
    private let userSerivce: IUserService
    
    init(userSerivce: IUserService) {
        self.userSerivce = userSerivce
    }
    
    func transform(input: Input) -> Output {
        input.getUsers
            .sink {[weak self] _ in
                self?.fetchUsers()
            }
            .store(in: &cancelables)
        return Output(reloadList: reloadListSubject.eraseToAnyPublisher(),
                      showError: showErrorSubject.eraseToAnyPublisher(),
                      showLoading: showLoadingSubject.eraseToAnyPublisher())
    }
    
    private func fetchUsers() {
        showLoadingSubject.send(true)
        self.userSerivce.getAll()
            .sink {[weak self] completion in
                if case .failure(let error) = completion {
                    self?.showLoadingSubject.send(false)
                    self?.showErrorSubject.send("Co Error")
                }
            } receiveValue: {[weak self] users in
                let items = users.map { UserViewModel(uid: $0.id, fullName: $0.fullName, userName: $0.userName, avatarURL: $0.avatarUrl)}
                self?.reloadListSubject.send(items)
                self?.showLoadingSubject.send(false)
            }
            .store(in: &cancelables)

    }
}

extension ListUserVM {
    struct Input {
        let getUsers: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reloadList: AnyPublisher<[UserViewModel], Never>
        let showError: AnyPublisher<String, Never>
        let showLoading: AnyPublisher<Bool, Never>
    }
}
