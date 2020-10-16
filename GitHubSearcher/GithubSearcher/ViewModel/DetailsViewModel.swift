//
//  DetailsViewModel.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/8/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import UIKit

final class DetailsViewModel {
    
    private let networkService: NetworkService
    private var userDetails: UserDetails?
    private var userRepos: [UserRepos] = [] {
        didSet {
            filteredRepos = userRepos
        }
    }
    private var filteredRepos: [UserRepos] = []
    var userUrl: String?
    
    init(networkService: NetworkService = GitHubNetworkService()) {
        self.networkService = networkService

    }
    
    func setDetails(usrDetails: UserDetails) {
        userDetails = usrDetails
    }
    
    func getName() -> String {
        return userDetails?.login ?? "No name"
    }
    
    func getUserAvatar(completion: @escaping(Data?) -> Void) {
        guard let avatarUrl = userDetails?.avatarUrl else {
            completion(nil)
            return
        }
        networkService.getUserAvatar(imgUrlStr: avatarUrl, completion: completion)
    }
    
    func getEmail() -> String {
        return userDetails?.email ?? "No email available"
    }
    
    func getLocation() -> String {
        return userDetails?.location ?? "No location available"
    }
    
    func getJoinDate() -> String {
        
        guard let unformatedDate = userDetails?.joinDate else { return "No join date" }
        let formattedDate = DateFormatters.extendedDateFormatter.date(from: unformatedDate)
        var stringDate = ""
        
        if let formattedDate = formattedDate {
            stringDate = DateFormatters.shortDateFormatter.string(from: formattedDate)
        }
        
        return stringDate
    }
    
    func getFollowers() -> Int {
        return userDetails?.followers ?? 0
    }
    
    func getFollowing() -> Int {
        return userDetails?.following ?? 0
    }
    
    func getBio() -> String {
        return userDetails?.bio ?? "No Bio available"
    }
    
    func getRepos(searchText: String?, completion: @escaping() -> Void) {
        if let searchText = searchText{
            filterArray(searchText: searchText)
            completion()
        } else {
            guard let reposUrl = userDetails?.reposUrl else {
                completion()
                return
            }
            networkService.getUserRepos(reposUrlString: reposUrl) { [weak self] (repoItems) in
                self?.userRepos = repoItems
                completion()
            }
        }
    }
    
    func getRepoName(index: Int) -> String {
        return filteredRepos[index].name
    }
    
    func getRepoForks(index: Int) -> Int {
        return filteredRepos[index].forks
    }
    
    func getRepoStars(index: Int) -> Int {
        return filteredRepos[index].stars
    }

    func getNumberOfRepos() -> Int {
        return filteredRepos.count
    }
    
    func getRepoUrl(index: Int) -> String? {
        return filteredRepos[index].htmlUrl
    }
    
    func filterArray(searchText: String) {
        if searchText.isEmpty {
            filteredRepos = userRepos
        } else {
            filteredRepos = userRepos.filter({ (repo) -> Bool in
                return repo.name.lowercased().contains(searchText.lowercased())
            })
        }
    }
}
