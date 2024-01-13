//
//  ListUserDataSource.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import UIKit

class ListUserDataSource: NSObject {
    private var items: [UserViewModel] = []
    func registerCell(_ tableView: UITableView) {
        let nib = UINib(nibName: UserViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: UserViewCell.identifier)
    }
    
    func updateItems(_ items: [UserViewModel]) {
        self.items = items
    }
}

extension ListUserDataSource: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.identifier) as! UserViewCell
        cell.model = items[indexPath.row]
        return cell
    }
}
