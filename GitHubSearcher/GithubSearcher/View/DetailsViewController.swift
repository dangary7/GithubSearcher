//
//  DetailsViewController.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/8/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bioLabel: UILabel!
    
    var viewModel: DetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserInfo()
        
        tableView.register(UINib.init(nibName: "ReposCell", bundle: nil), forCellReuseIdentifier: "ReposCell")
        
        viewModel?.getRepos(searchText: nil) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func setUserInfo() {
        viewModel?.getUserAvatar { [weak self] (imageData) in
            guard let imageData = imageData else { return }
            DispatchQueue.main.async {
                self?.userAvatar.image = UIImage(data: imageData)
            }
        }
        
        userNameLabel.text = "UserName: \(viewModel?.getName() ?? "No name")"
        emailLabel.text = viewModel?.getEmail()
        locationLabel.text = viewModel?.getLocation()
        joinDateLabel.text = "Join date: \(viewModel?.getJoinDate() ?? "No join date")"
        followersLabel.text = "\(viewModel?.getFollowers() ?? 0)  Followers"
        followingLabel.text = "Following \(viewModel?.getFollowing() ?? 0)"
        bioLabel.text = viewModel?.getBio()
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRepos() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReposCell", for: indexPath) as! ReposCell
        
        cell.repoName.text = viewModel?.getRepoName(index: indexPath.row)
        cell.repoForks.text = "\(viewModel?.getRepoForks(index: indexPath.row) ?? 0) Forks"
        cell.repoStars.text = "\(viewModel?.getRepoStars(index: indexPath.row) ?? 0) Stars"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel,
            let url = URL(string: viewModel.getRepoUrl(index: indexPath.row) ?? ""),
            UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}

extension DetailsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getRepos(searchText: searchText) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
