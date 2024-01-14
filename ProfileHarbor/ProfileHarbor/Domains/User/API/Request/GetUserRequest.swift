//
//  GetUserRequest.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 14/01/2024.
//

import Foundation

struct GetUserRequest: Request {
    
    typealias Reps = GithubUserData
    var path: String = "users"
    var method: HTTPMethod = .get
    var body: [String: Any]? = nil
    var headers: [String: String]? = nil
    var queryParam: [String : Any]? = nil
 
    init(username: String) {
        self.path = "users/\(username)"
    }
    
}
