//
//  GitHubNetworkService.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/10/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import Foundation

final class GitHubNetworkService: NetworkService {
    
    func getUsersInfo(searchText: String, completion: @escaping ([UserItems]) -> Void) {
        let searchUrlString = "https://api.github.com/search/users?q=\(searchText)"
        
        guard let url = URL(string: searchUrlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            do {
                let jsonData = try JSONDecoder().decode(GitHubUsers.self, from: data)
                completion(jsonData.items)
            } catch {
                completion([])
            }
        }.resume()
    }
    
    func getUserDetailsInfo(userName: String, completion: @escaping (UserDetails?) -> Void) {
        let userUrlString = "https://api.github.com/users/\(userName)"
        
        guard let url = URL(string: userUrlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let jsonUserData = try JSONDecoder().decode(UserDetails.self, from: data)
                completion(jsonUserData)
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func getUserAvatar(imgUrlStr: String, completion: @escaping (Data?) -> Void) {
        if let cacheImg = ImageCache.shared.getImage(url: imgUrlStr) {
            completion(cacheImg)
        } else {
            guard let imgUrl = URL(string: imgUrlStr) else {
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: imgUrl) { (data, _, error) in
                if let data = data {
                    ImageCache.shared.saveImage(url: imgUrlStr, image: data)
                }
                completion(data)
            }.resume()
        }
    }
    
    func getUserRepos(reposUrlString: String, completion: @escaping ([UserRepos]) -> Void) {
        let reposUrlString = reposUrlString
        
        guard let url = URL(string: reposUrlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            do {
                let jsonReposData = try JSONDecoder().decode([UserRepos].self, from: data)
                completion(jsonReposData)
            } catch {
                completion([])
            }
        }.resume()
    }
}
