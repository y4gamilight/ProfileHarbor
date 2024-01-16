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
    private var openWebViewSubject = PassthroughSubject<URL?, Never>()
    private var cancelables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bindEvent() {
        let input = UserDetailVM.Input(getDetail: getDetailSubject.eraseToAnyPublisher(), openWebView: openWebViewSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.reloadUserSection
            .receive(on: RunLoop.main)
            .sink {[weak self] userInfo in
                self?.dataSource.userInfo = userInfo
                self?.tableView.reloadSections([UserDetailDataSource.Section.user.rawValue], with: .automatic)
            }
            .store(in: &cancelables)
        output.reloadReposSection
            .receive(on: RunLoop.main)
            .sink {[weak self] repositories in
                self?.dataSource.repositories = repositories
                self?.tableView.reloadSections([UserDetailDataSource.Section.repository.rawValue], with: .automatic)
            }
            .store(in: &cancelables)
    }
    
    override func bindData() {
        dataSource.onDidSelectRepository = {[weak self] url in
            self?.openWebViewSubject.send(url)
        }
    }

    override func configuration() {
        dataSource.registerCell(tableView)
        
        getDetailSubject.send(())
    }
}
