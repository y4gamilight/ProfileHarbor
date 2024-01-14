//
//  UserInfoCellModel.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import Foundation

struct UserInfoCellModel {
    let avatarUrl: String
    let fullName: String
    let userName: String
    let numOfFollowings: Int
    let numOfFollowers: Int
    let isLoading: Bool
    
    init() {
        self.avatarUrl = ""
        self.fullName = ""
        self.userName = ""
        self.numOfFollowings = 0
        self.numOfFollowers = 0
        self.isLoading = false
    }
    
    init(avatarUrl: String, fullName: String, userName: String, numOfFollowings: Int, numOfFollowers: Int, isLoading: Bool) {
        self.avatarUrl = avatarUrl
        self.fullName = fullName
        self.userName = userName
        self.numOfFollowings = numOfFollowings
        self.numOfFollowers = numOfFollowers
        self.isLoading = isLoading
    }
    
}
