//
//  UserDetailsModel.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/10/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import Foundation

struct UserDetails: Decodable {
    let login: String
    let email: String?
    let location: String?
    let joinDate: String
    let followers: Int
    let following: Int
    let bio: String?
    let publicRepos: Int
    let avatarUrl: String
    let reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case email
        case location
        case joinDate = "created_at"
        case followers
        case following
        case bio
        case publicRepos = "public_repos"
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
    }
}
