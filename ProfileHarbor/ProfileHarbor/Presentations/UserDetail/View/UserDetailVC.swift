//
//  UserDetailVC.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import UIKit
import Combine

class UserDetailVC: BaseVC<UserDetailVM> {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: UserDetailDataSource!
    private var getDetailSubject = PassthroughSubject<Void, Never>()
    private var cancelables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bindEvent() {
        let input = UserDetailVM.Input(getDetail: getDetailSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.reloadData
            .receive(on: RunLoop.main)
            .sink {[weak self] userInfo, repositories in
                self?.dataSource.userInfo = userInfo
                self?.dataSource.repositories = repositories
                self?.tableView.reloadData()
            }
            .store(in: &cancelables)
    }
    
    override func bindData() {
        
    }

    override func configuration() {
        dataSource.registerCell(tableView)
        
        getDetailSubject.send(())
    }
}
