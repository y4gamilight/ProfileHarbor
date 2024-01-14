//
//  UITableView+Ext.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import UIKit

extension UITableView {
    func registerCell(of cellClass: BaseTableViewCell.Type) {
        let nib = UINib(nibName: cellClass.nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cellClass.identifier)
    }
}
