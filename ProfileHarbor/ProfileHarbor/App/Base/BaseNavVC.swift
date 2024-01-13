//
//  BaseNavVC.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//
imports UIKit

class BaseNavController<ViewModel: BaseVM>: UINavigationController {
    
    init(baseVC: BaseVC<ViewModel>) {
        super.init(rootViewController: baseVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindData()
        bindEvent()
    }
    
    func setupUI() {}
    
    func setupConstraints() {}
    
    func bindData() {}
    
    func bindEvent() {}
    
}
