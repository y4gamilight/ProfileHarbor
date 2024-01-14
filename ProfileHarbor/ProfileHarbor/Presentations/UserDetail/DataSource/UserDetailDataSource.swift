//
//  UserDetailDataSource.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import Foundation
import UIKit

final class UserDetailDataSource: NSObject {
    enum Section: Int {
        case user
        case repository
    }
    var repositories: [RepositoryCellModel] = []
    var userInfo = UserInfoCellModel()
    
    func registerCell(_ tableView: UITableView) {
        tableView.registerCell(of: UserInfoViewCell.self)
        tableView.registerCell(of: RepositoryViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension UserDetailDataSource: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Section.user.rawValue ? 1 : repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == Section.user.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoViewCell.identifier) as! UserInfoViewCell
            cell.model = userInfo
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryViewCell.identifier) as!
            RepositoryViewCell
            cell.model = repositories[row]
            return cell
        }
    }
}
