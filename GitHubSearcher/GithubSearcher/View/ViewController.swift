//
//  ViewController.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/8/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    var viewModel = ViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "UsersCell", bundle: nil), forCellReuseIdentifier: "UsersCell")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let detailsViewController = segue.destination as? DetailsViewController {
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    detailsViewController.viewModel = viewModel.detailViewModelForIndex(index: selectedIndex.row)
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersCell
        
        viewModel.getUserAvatar(index: indexPath.row) { (imageData) in
            guard let imageData = imageData else { return }
            DispatchQueue.main.async {
                cell.usrAvatar.image = UIImage(data: imageData)
            }
        }
        cell.usrName.text = viewModel.getUserName(index: indexPath.row)
        viewModel.getNumberOfRepos(index: indexPath.row) { (publicRepos) in
            DispatchQueue.main.async {
                cell.usrRepos.text = "Repos: \(publicRepos)"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload(_:)), object: searchBar)
        perform(#selector(reload(_:)), with: searchBar, afterDelay: 0.5)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let qText = searchBar.text else { return }
        viewModel.getUsrsInfo(searchText: qText) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
