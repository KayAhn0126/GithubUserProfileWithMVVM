//
//  SearchViewController.swift
//  GithubUserProfileWithMVVM
//
//

import UIKit
import Combine
import Kingfisher

class UserProfileViewController: UIViewController {
    var subscriptions = Set<AnyCancellable>()
    
    var viewModel: SearchViewModel!
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var firstDateLabel: UILabel!
    @IBOutlet weak var latestUpdateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel(network: NetworkService(configuration: .default))
        setupUI()
        embendSearchControl()
        bind()
    }

    // setupUI
    private func setupUI() {
        thumbnail.layer.cornerRadius = 80
    }
    
    // search control
    private func embendSearchControl() {
        self.navigationItem.title = "Search"
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "kayahn0126"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    // bind
    private func bind() {
        viewModel.selectedUser
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                self.nameLabel.text = self.viewModel.name
                self.loginLabel.text = self.viewModel.login
                self.followerLabel.text = self.viewModel.follower
                self.followingLabel.text = self.viewModel.following
                self.firstDateLabel.text = self.viewModel.firstDate
                self.latestUpdateLabel.text = self.viewModel.latestUpdate
                self.thumbnail.kf.setImage(with: self.viewModel.avatarUrl)
            }.store(in: &subscriptions)
    }
}

extension UserProfileViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text
    }
}

extension UserProfileViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(userText: searchBar)
    }
}
