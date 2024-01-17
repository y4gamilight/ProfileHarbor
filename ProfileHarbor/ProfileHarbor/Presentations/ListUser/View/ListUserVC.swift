//
//  ListUserVC.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import UIKit
import Combine

final class ListUserVC: BaseVC<ListUserVM> {
    @IBOutlet weak var usersTableView: UITableView!
    var dataSource: ListUserDataSource!
    
    private var cancelables = Set<AnyCancellable>()
    private var getUsersSubject = PassthroughSubject<Void, Never>()
    private var loadMoreSubject = PassthroughSubject<Void, Never>()
    private var selectedUserSubject = PassthroughSubject<String, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        usersTableView.refreshControl = refreshControl
        
    }
    
    override func bindData() {
        let input = ListUserVM.Input(getUsers: getUsersSubject.eraseToAnyPublisher(), loadMore: loadMoreSubject.eraseToAnyPublisher(), selectedUser: selectedUserSubject.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.showLoading
            .receive(on: RunLoop.main)
            .sink {[weak self] isShow in
                isShow ? self?.showLoading() : self?.hideLoading()
            }
            .store(in: &cancelables)
        
        output.showError
            .receive(on: RunLoop.main)
            .sink {[weak self] message in
                self?.showErrorToastMessage(message)
            }
        
            .store(in: &cancelables)
        
        output.appendItems
            .receive(on: RunLoop.main)
            .sink {[weak self] items in
                self?.dataSource.appendItems(items)
                self?.usersTableView.reloadData()
                self?.usersTableView.refreshControl?.endRefreshing()
            }
            .store(in: &cancelables)
        
        output.updateItems
            .receive(on: RunLoop.main)
            .sink {[weak self] items in
                self?.dataSource.updateItems(items)
                self?.usersTableView.reloadData()
                self?.usersTableView.refreshControl?.endRefreshing()
            }
            .store(in: &cancelables)
    }
    
    override func bindEvent() {
        dataSource.onLoadMore = {[weak self] in
            self?.loadMoreSubject.send(())
        }
        
        dataSource.onDidSelectItem = {[weak self] username in
            self?.selectedUserSubject.send(username)
        }
        
        dataSource.onBindNumOfUser = {[weak self] num in
            self?.title = StringKey.textNumUsers(num)
        }
    }
    
    override func configuration() {
        usersTableView.dataSource = dataSource
        usersTableView.delegate = dataSource
        dataSource.registerCell(usersTableView)
        getUsersSubject.send(())
    }
    
    @objc
    private func pullToRefresh() {
        getUsersSubject.send(())
    }
}
