//
//  GitHubUsersModel.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/8/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import Foundation

struct GitHubUsers: Decodable {
    let items: [UserItems]
}
