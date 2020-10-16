//
//  ViewModel.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/8/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import UIKit

final class ViewModel {

    private let networkService: NetworkService
    private var users: [UserItems] = [] {
        didSet {
            //Keep a one to one relationship between userDetails and users so we can pass the correct data when navigating to the details screen.
            userDetails = [UserDetails?](repeating: nil, count: users.count)
        }
    }
    private var userDetails: [UserDetails?] = []
    
    init(networkService: NetworkService = GitHubNetworkService()) {
        self.networkService = networkService
    }
    
    func getUsrsInfo(searchText: String, completion: @escaping() -> Void) {
        networkService.getUsersInfo(searchText: searchText) { [weak self] (userItems) in
            self?.users = userItems
            completion()
        }
    }
    
    func getNumberOfUsers() -> Int{
        return users.count
    }
    
    func getUserName(index: Int) -> String {
        return users[index].login
    }
    
    func getUserAvatar(index: Int, completion: @escaping(Data?) -> Void) {
        networkService.getUserAvatar(imgUrlStr: users[index].avatarUrl, completion: completion)
    }
    
    func getNumberOfRepos(index: Int, completion: @escaping(Int) -> Void) {
        networkService.getUserDetailsInfo(userName: users[index].login) { [weak self] (userDetails) in
            self?.userDetails[index] = userDetails
            completion(userDetails?.publicRepos ?? 0)
        }
    }
    
    func detailViewModelForIndex(index: Int) -> DetailsViewModel? {
        guard let user = userDetails[index] else { return nil }
        let detailsVM = DetailsViewModel()
        detailsVM.setDetails(usrDetails: user)
        
        return detailsVM
    }
}
