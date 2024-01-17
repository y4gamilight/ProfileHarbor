//
//  UIView+Ext.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 17/01/2024.
//

import UIKit

extension UIView {
    
    func fillHorizontalSuperview(constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -constant).isActive = true
    }
    
    func fillVerticalSuperview(constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
    }
}
