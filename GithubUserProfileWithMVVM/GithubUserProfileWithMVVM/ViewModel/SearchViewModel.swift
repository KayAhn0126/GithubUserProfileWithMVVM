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
    @Published private(set) var user: UserProfile?
    var network: NetworkService
    var subscription = Set<AnyCancellable>()
    
    
    init(network: NetworkService) {
        self.network = network
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
                    self.user = nil
                    print("Error Code : \(error)")
                case.finished :
                    print("Completed : \(completion)")
                    break
                }
            } receiveValue: { [unowned self] value in
                self.user = value
            }.store(in: &subscription)
    }
}
