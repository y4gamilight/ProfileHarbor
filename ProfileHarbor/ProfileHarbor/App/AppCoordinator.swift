//
//  AppCoordinator.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 12/01/2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    let window: UIWindow?
    lazy var rootVC: UINavigationController = {
        let vm = ListUserVM(userSerivce: Dependencies.userService)
        vm.coordinator = self
        let listUserVC: ListUserVC = ListUserVC.from(storyboard: Storyboards.main, with: vm)
        listUserVC.dataSource = ListUserDataSource()
        let navVC = BaseNavController(baseVC: listUserVC)
        navVC.isNavigationBarHidden = true
        return navVC
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard let window = self.window else { return }
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
    }
        
    override func finsih() {
        
    }
}
