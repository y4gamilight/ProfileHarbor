//
//  GetRepositoriesRequest.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 16/01/2024.
//

import Foundation

struct GetRepositoriesRequest: Request {
    enum Key: String {
        case page
        case perPage = "per_page"
        case type
        case sort
        case direction
    }
    typealias Reps = GitHubRepositoryData
    var path: String = "users"
    var method: HTTPMethod = .get
    var body: [String: Any]? = nil
    var headers: [String: String]? = nil
    var queryParam: [String : Any]? = nil
 
    init(username: String, page: Int = 1, pageSize: Int = Constants.Pagination.maxPageSize) {
        path = "users/\(username)/repos"
        let dict = [
            Key.perPage.rawValue : pageSize,
            Key.page.rawValue : page,
        ]
        self.queryParam = dict
    }
    
}
