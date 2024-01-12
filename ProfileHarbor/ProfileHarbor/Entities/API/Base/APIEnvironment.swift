//
//  APIEnvironment.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 12/01/2024.
//

import Foundation

enum APIEnvironment {
    case dev
    case prod
    
    var baseURL: String {
        return "https://api.github.com/"
    }
    
    var headerDefault: [String: String] {
        return ["Authorization": "Bearer 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",
                "X-GitHub-Api-Version": "2022-11-28",
                "accept": "application/vnd.github+json"]
    }
}
