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
        viewModel.$user
            .receive(on: RunLoop.main)
            .sink { [unowned self] result in
                self.update(result)
            }.store(in: &subscriptions)
    }
    
    private func update(_ user: UserProfile?) {
        guard let user = user else {
            self.nameLabel.text = "Name : "
            self.loginLabel.text = "Github id : "
            self.followerLabel.text = "followers : 0"
            self.followingLabel.text = "following : 0"
            self.firstDateLabel.text = "first date : yesterday"
            self.latestUpdateLabel.text = "latest update : today"
            self.thumbnail.image = nil
            return
        }
        self.nameLabel.text = "Name : " + user.name
        self.loginLabel.text = "Github id : " + user.login
        self.followerLabel.text = "followers : \(user.followers)"
        self.followingLabel.text = "following : \(user.following)"
        self.firstDateLabel.text = "first date : \(user.firstDate)"
        self.latestUpdateLabel.text = "latest update : \(user.latestupdateDate)"
        self.thumbnail.kf.setImage(with: user.avatarUrl)
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
