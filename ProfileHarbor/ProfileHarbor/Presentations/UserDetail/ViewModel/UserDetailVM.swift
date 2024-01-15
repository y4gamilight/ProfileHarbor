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
    private var reloadUserSectionSubject = PassthroughSubject<UserInfoCellModel, Never>()
    private var reloadReposSectionSubject = PassthroughSubject<[RepositoryCellModel], Never>()
    private var fetchReposSubject = CurrentValueSubject<[RepositoryCellModel], Never>([])
    private var cancelables = Set<AnyCancellable>()
    
    var coordinator: AppCoordinator!
    private var userService: IUserService
    private var repoService: IRepositoryService
    private var username: String
    private var currentIndex: Int = 1
    init(username: String, userService: IUserService, repoService: IRepositoryService) {
        self.username = username
        self.userService = userService
        self.repoService = repoService
    }
    
    func transform(input: Input) -> Output {
        input.getDetail
            .sink {[weak self] in
                self?.fetchDetail()
                self?.fetchAllRepos()
            }
            .store(in: &cancelables)
        return Output(reloadUserSection: reloadUserSectionSubject.eraseToAnyPublisher(), reloadReposSection: reloadReposSectionSubject.eraseToAnyPublisher(), showError: showErrorSubject.eraseToAnyPublisher(), showLoading: showLoadingSubject.eraseToAnyPublisher())
    }
    
    
    private func fetchDetail() {
        showLoadingSubject.send(true)
        userService.getDetailByUserName(username)
            .sink {[weak self] completion in
                if case .failure = completion {
                    self?.showLoadingSubject.send(false)
                }
            } receiveValue: {[weak self] user in
                let userInfo = UserInfoCellModel(avatarUrl: user.avatarUrl, fullName: user.fullName, userName: user.userName, numOfFollowings: user.following, numOfFollowers: user.followers, isLoading: true)
                self?.showLoadingSubject.send(false)
                self?.reloadUserSectionSubject.send((userInfo))
            }
            .store(in: &cancelables)
    }
    
    private func fetchAllRepos() {
        loadRepos()
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: {[weak self] results  in
                let models = results
                    .filter { $0.isFork == false }
                    .map { RepositoryCellModel(id: $0.id, name: $0.name, link: URL(string: $0.url), numOfStars: $0.starCount, languages: $0.language ?? "") }
                self?.reloadReposSectionSubject.send(models)
            })
            .store(in: &cancelables)
    }
    
    func loadRepos() -> AnyPublisher<[GitHubRepository], RepositoryError> {
        let publishers = CurrentValueSubject<Int, Never>(1)
        return publishers
            .flatMap({ index in
                self.currentIndex = index
                return self.repoService.getAll(by: self.username, page: index)
            })
            .handleEvents(receiveOutput: { results in
                if results.count >= Constants.Pagination.maxPageSize {
                    publishers.send( self.currentIndex + 1)
                } else {
                    publishers.send(completion: .finished)
                }
            })
            .reduce([GitHubRepository](), { olds, news in
                return olds + news
            })
            .eraseToAnyPublisher()
    }
}

extension UserDetailVM {
    
    struct Input {
        let getDetail: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reloadUserSection: AnyPublisher<UserInfoCellModel, Never>
        let reloadReposSection: AnyPublisher<[RepositoryCellModel], Never>
        let showError: AnyPublisher<String, Never>
        let showLoading: AnyPublisher<Bool, Never>
    }
    typealias C = AppCoordinator
}
