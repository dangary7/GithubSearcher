//
//  UserItemsModel.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/10/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import Foundation

struct UserItems: Decodable {
    let login: String
    let avatarUrl: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case url
    }
}
