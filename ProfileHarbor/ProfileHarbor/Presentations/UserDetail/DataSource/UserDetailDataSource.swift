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
    var repositories: [RepositoryCellModel] = [] {
        didSet {
            isFetched = true
        }
    }
    
    private var isFetched: Bool = false
    var userInfo = UserInfoCellModel()
    var onDidSelectRepository: ((URL?) -> Void)?
    
    func registerCell(_ tableView: UITableView) {
        tableView.registerCell(of: UserInfoViewCell.self)
        tableView.registerCell(of: RepositoryViewCell.self)
        tableView.registerCell(of: RepositoryStatusCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension UserDetailDataSource: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == Section.repository.rawValue ? "List repositories" : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Section.user.rawValue ? 1 : (repositories.isEmpty ? 1 : repositories.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == Section.user.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoViewCell.identifier) as! UserInfoViewCell
            cell.model = userInfo
            return cell
        } else {
            if repositories.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryStatusCell.identifier) as!
                RepositoryStatusCell
                cell.updateStatus(isFetched)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryViewCell.identifier) as!
                RepositoryViewCell
                cell.model = repositories[row]
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.repository.rawValue else { return }
        let item = repositories[indexPath.row]
        onDidSelectRepository?(item.link)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
