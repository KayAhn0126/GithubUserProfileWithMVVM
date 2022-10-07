//
//  UserProfile.swift
//  GithubUserProfileWithMVVM
//
//

import Foundation

struct UserProfile: Hashable, Identifiable, Decodable {
    
    var id: Int64
    var login: String
    var name: String
    var avatarUrl: URL
    var htmlUrl: String
    var followers: Int
    var following: Int
    var firstDate: String
    var latestupdateDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case followers
        case following
        case firstDate = "created_at"
        case latestupdateDate = "updated_at"
    }
}
