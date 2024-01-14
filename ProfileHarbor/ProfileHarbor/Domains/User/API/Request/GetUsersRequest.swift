//
//  GetUsersRequest.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//
import Foundation

struct GetUsersRequest: Request {
    enum Key: String {
        case since
        case perPage = "per_page"
    }
    typealias Reps = GithubUserData
    var path: String = "users"
    var method: HTTPMethod = .get
    var body: [String: Any]? = nil
    var headers: [String: String]? = nil
    var queryParam: [String : Any]? = nil
 
    init(sinceId: Int? = nil, pageSize: Int = Constants.Pagination.maxPageSize) {
        var dict = [
            Key.perPage.rawValue : pageSize
        ]
        if let id = sinceId {
            dict[Key.since.rawValue] = id
        }
        self.queryParam = dict
    }
    
}
