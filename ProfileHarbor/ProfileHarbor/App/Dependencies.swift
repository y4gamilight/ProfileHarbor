//
//  Dependencies.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 12/01/2024.
//

import Foundation

class Dependencies {
    static let shared = Dependencies()
    
    static let userService: IUserService = shared.internalUserService;
    
    private lazy var internalUserService: IUserService = {
        return UserService(api: self.internalAPIClient)
    }()
    
    private lazy var internalAPIClient: APIClient = {
       return APIClient()
    }()
}
