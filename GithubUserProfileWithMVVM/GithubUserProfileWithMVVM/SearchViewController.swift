//
//  SearchViewController.swift
//  GithubUserProfileWithMVVM
//
//

import UIKit
import Combine
import Kingfisher

class UserProfileViewController: UIViewController {
    @Published private(set) var user: UserProfile?
    var subscriptions = Set<AnyCancellable>()
    
    var network = NetworkService(configuration: .default)
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var firstDateLabel: UILabel!
    @IBOutlet weak var latestUpdateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        $user
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
        print("search: \(keyword)")
    }
}

extension UserProfileViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("button clicked: \(searchBar.text)")
        
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }
        
        //Resource
        let resource = Resource<UserProfile>(
            base: "https://api.github.com/",
            path: "users/\(keyword)",
            params: [:],
            header: ["Content-Type": "application/json"]
        )
        
        // Network Service
        network.load(resource)
            .receive(on: RunLoop.main) //subscriber를 main 스레드에서 실행.
            .sink { completion in
                switch completion {
                case.failure(let error):
                    self.user = nil
                    print("Error Code : \(error)")
                case.finished :
                    print("Completed : \(completion)")
                    break
                }
            } receiveValue: { value in
                self.user = value
            }.store(in: &subscriptions)
    }
}
