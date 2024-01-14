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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindData() {
        let input = ListUserVM.Input(getUsers: getUsersSubject.eraseToAnyPublisher())
        
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
                self?.showErorMessage(message)
            }
        
            .store(in: &cancelables)
        
        output.reloadList
            .receive(on: RunLoop.main)
            .sink {[weak self] items in
                self?.dataSource.updateItems(items)
                self?.usersTableView.reloadData()
            }
            .store(in: &cancelables)
            

    }
    
    override func configuration() {
        usersTableView.dataSource = dataSource
        usersTableView.delegate = dataSource
        dataSource.registerCell(usersTableView)
        getUsersSubject.send(())
    }
}
