//
//  NetworkService.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/10/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import Foundation

protocol NetworkService {
    
    func getUsersInfo(searchText: String, completion: @escaping ([UserItems]) -> Void)
    
    func getUserDetailsInfo(userName: String, completion: @escaping (UserDetails?) -> Void)
    
    func getUserAvatar(imgUrlStr: String ,completion: @escaping(Data?) -> Void)
    
    func getUserRepos(reposUrlString: String, completion: @escaping ([UserRepos]) -> Void)
}
