//
//  GetUsersRequest.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//
import Foundation

struct GetUsersRequest: Request {
    
    typealias Reps = GithubUserData
    var path: String = "users"
    var method: HTTPMethod = .get
    var body: [String: Any]? = nil
    var headers: [String: String]? = nil
    var queryParam: [String : Any]? = nil

}
