//
//  GithubRepositoryData.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 16/01/2024.
//

import Foundation

struct GitHubRepositoryData: Response {
    let id: Int
    let nodeID: String
    let name: String
    let fullName: String
    let isPrivate: Bool
    let owner: GithubUserData
    let htmlURL: String
    let description: String?
    let isFork: Bool
    let url: String
    let forksURL: String
    let language: String?
    let hasIssues: Bool
    let hasProjects: Bool
    let hasDownloads: Bool
    let allowForking: Bool
    let isTemplate: Bool
    let visibility: String
    let forks: Int
    let openIssues: Int
    let watchers: Int
    let defaultBranch: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, owner, description, url, forks, watchers, language, visibility
        case nodeID = "node_id"
        case fullName = "full_name"
        case isPrivate = "private"
        case htmlURL = "html_url"
        case isFork = "fork"
        case forksURL = "forks_url"
        case hasIssues = "has_issues"
        case hasProjects = "has_projects"
        case hasDownloads = "has_downloads"
        case allowForking = "allow_forking"
        case isTemplate = "is_template"
        case openIssues = "open_issues"
        case defaultBranch = "default_branch"
    }
}
