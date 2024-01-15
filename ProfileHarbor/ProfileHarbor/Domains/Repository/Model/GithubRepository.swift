//
//  GithubRepository.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 16/01/2024.
//

import Foundation

struct GitHubRepository {
    let id: Int
    let nodeID: String
    let name: String
    let fullName: String
    let isPrivate: Bool
    let url: String
    let forksURL: String
    let language: String?
    let isFork: Bool
}
