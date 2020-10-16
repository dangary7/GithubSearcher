//
//  UserReposModel.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/10/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import Foundation

struct UserRepos: Decodable {
    let name: String
    let htmlUrl: String
    let forks: Int
    let stars: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case htmlUrl = "html_url"
        case forks
        case stars = "stargazers_count"
    }
}
