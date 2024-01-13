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
    
    var fetchedError = PassthroughSubject<String, Never>()
    private var reloadListSubject = PassthroughSubject<[UserViewModel], Never>()
    func transform(input: Input) -> Output {
        return Output(reloadList: reloadListSubject.eraseToAnyPublisher(),
                      showError: fetchedError.eraseToAnyPublisher())
    }
    
    private let userSerivce: IUserService
    
    init(userSerivce: IUserService) {
        self.userSerivce = userSerivce
    }
}

extension ListUserVM {
    struct Input {
        let getUsers: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reloadList: AnyPublisher<[UserViewModel], Never>
        let showError: AnyPublisher<String, Never>
    }
}
