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
    
    func transform(input: Input) -> Output {
        input.getDetail
            .sink {[weak self] in
                self?.fetchDetail()
            }
            .store(in: &cancelables)
        return Output(reloadData: reloadDataSubject.eraseToAnyPublisher(), showError: showErrorSubject.eraseToAnyPublisher(), showLoading: showLoadingSubject.eraseToAnyPublisher())
    }
    
    var coordinator: AppCoordinator!
    private var userService: IUserService
    private var userId: Int
    init(userId: Int, userService: IUserService) {
        self.userId = userId
        self.userService = userService
    }
    
    private func fetchDetail() {
        showLoadingSubject.send(true)
        let model = UserInfoCellModel(userName: "Le Tan Thanh")
        let repositories = [
            RepositoryCellModel(id: 1, name: "thanhlt", link: URL(string: "https://"), numOfStars: 10, languages: "Java"),
        RepositoryCellModel(id: 2, name: "thanhlt2", link: URL(string: "https://"), numOfStars: 10, languages: "Java")
        ]
        reloadDataSubject.send((model, repositories))
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
