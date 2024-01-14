//
//  BaseTableViewCell.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    static var nibName: String {
        return String(describing: self)
    }
    static var identifier: String {
        return String(describing: self)
    }
}
