//
//  ListUserVM.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import Foundation
import Combine

final class ListUserVM: BaseVM {
    var fetchedError = PassthroughSubject<String, Never>()
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    private let userSerivce: IUserService
    
    init(userSerivce: IUserService) {
        self.userSerivce = userSerivce
    }
}

extension ListUserVM {
    struct Input {
        private let getUsers: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reloadList: AnyPublisher<Void, Never>
        let showError: AnyPublisher<String, Never>
    }
}
