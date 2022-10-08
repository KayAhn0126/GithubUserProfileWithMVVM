//
//  SearchViewModel.swift
//  GithubUserProfileWithMVVM
//
//  Created by Kay on 2022/10/07.
//

import Foundation
import UIKit
import Combine

final class SearchViewModel {
    
    var network: NetworkService
    var subscription = Set<AnyCancellable>()
    
    var selectedUser: CurrentValueSubject<UserProfile?, Never>
    
    var name: String {
        guard let name = selectedUser.value?.name else { return "Name : " }
        return "Name : \(name)"
    }
    
    var login: String {
        guard let login = selectedUser.value?.login else { return "Github id : " }
        return "Github id : \(login)"
    }
    var follower: String {
        guard let followers = selectedUser.value?.followers else { return "followers : 0" }
        return "followers : \(followers)"
    }
    var following: String {
        guard let following = selectedUser.value?.following else { return "following : 0" }
        return "following : \(following)"
    }
    
    var firstDate: String {
        guard let firstDate = selectedUser.value?.following else { return "first date : yesterday" }
        return "first date : \(firstDate)"
    }
    
    var latestUpdate: String {
        guard let latestUpdate = selectedUser.value?.following else { return "latest update : today" }
        return "latest update : \(latestUpdate)"
    }
    
    var avatarUrl: URL? {
        guard let profilePicture = selectedUser.value?.avatarUrl else { return nil }
        return profilePicture
    }
    
    init(network: NetworkService, selectedUser: UserProfile? = nil) {
        self.network = network
        self.selectedUser = CurrentValueSubject(selectedUser)
    }
    
    // Data => Output
    
    // User Action => Input
    func search(userText: UISearchBar) {
        guard let keyword = userText.text, !keyword.isEmpty else { return }
        
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
                    self.selectedUser.value = nil
                    print("Error Code : \(error)")
                case.finished :
                    print("Completed : \(completion)")
                    break
                }
            } receiveValue: { [unowned self] value in
                self.selectedUser.send(value)
            }.store(in: &subscription)
    }
}
