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
        output.reloadList
            .sink {[weak self] items in
                self?.dataSource.updateItems(items)
                self?.usersTableView.reloadData()
            }
            .store(in: &cancelables)
            

    }
    
    override func configuration() {
        dataSource.registerCell(usersTableView)
    }
}
