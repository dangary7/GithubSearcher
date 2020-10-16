//
//  MockNetworkService.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/8/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import UIKit

final class MockNetworkService: NetworkService  {

    func getUsersInfo(searchText: String, completion: @escaping ([UserItems]) -> Void) {
        guard let jsonUrl = Bundle.main.url(forResource: "usersInformation", withExtension: "json") else {
            completion([])
            return
        }
        do {
            let jsonData = try Data(contentsOf: jsonUrl)
            
            let usrsInformation = try JSONDecoder().decode(GitHubUsers.self, from: jsonData)
            
            completion(usrsInformation.items)
            
        } catch {
            completion([])
        }
    }
    
    func getUserDetailsInfo(userName: String, completion: @escaping (UserDetails?) -> Void) {
        guard let jsonUrl = Bundle.main.url(forResource: "userDetail", withExtension: "json") else {
            completion(nil)
            return
        }
        do {
            let jsonData = try Data(contentsOf: jsonUrl)
            
            let usrDetails = try JSONDecoder().decode(UserDetails.self, from: jsonData)
            
            completion(usrDetails)
            
        } catch {
            completion(nil)
        }
    }

    func getUserAvatar(imgUrlStr: String ,completion: @escaping(Data?) -> Void) {
        
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
        guard let jsonUrl = Bundle.main.url(forResource: "repos", withExtension: "json") else {
            completion([])
            return
        }
        do {
            let jsonData = try Data(contentsOf: jsonUrl)
            
            let usrRepos = try JSONDecoder().decode([UserRepos].self, from: jsonData)
            
            completion(usrRepos)
            
        } catch {
            completion([])
        }
    }
}
