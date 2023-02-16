//
//  SearchRepoResponse.swift
//  SearchGithubRepo
//
//  Created by KyeongKyu Lee on 2023/02/16.
//

import Foundation

// MARK: - SearchRepoResponse
struct SearchRepoResponse: Codable {
    let total_count              : Int
    let incomplete_results       : Bool
    let items                    : [Item]
    
    enum CodingKeys: String, CodingKey {
        case total_count         = "total_count"
        case incomplete_results  = "incomplete_results"
        case items               = "items"
    }
}

// MARK: - Item
struct Item: Codable {
    let name            : String
    let full_name       : String
    let owner           : Owner
    let html_url        : String
    
    enum CodingKeys: String, CodingKey {
        case name       = "name"
        case full_name  = "full_name"
        case owner      = "owner"
        case html_url   = "html_url"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login                     : String
    let id                        : Int
    let node_id                   : String
    let avatar_url                : String
    let gravatar_id               : String
    let url                       : String
    let received_events_url       : String
    let type                      : String
    let html_url                  : String
    let followers_url             : String
    let following_url             : String
    let gists_url                 : String
    let starred_url               : String
    let subscriptions_url         : String
    let organizations_url         : String
    let repos_url                 : String
    let events_url                : String
    let site_admin                : Bool
    
    enum CodingKeys: String, CodingKey {
        case login                = "login"
        case id                   = "id"
        case node_id              = "node_id"
        case avatar_url           = "avatar_url"
        case gravatar_id          = "gravatar_id"
        case url                  = "url"
        case received_events_url  = "received_events_url"
        case type                 = "type"
        case html_url             = "html_url"
        case followers_url        = "followers_url"
        case following_url        = "following_url"
        case gists_url            = "gists_url"
        case starred_url          = "starred_url"
        case subscriptions_url    = "subscriptions_url"
        case organizations_url    = "organizations_url"
        case repos_url            = "repos_url"
        case events_url           = "events_url"
        case site_admin           = "site_admin"
    }
}


