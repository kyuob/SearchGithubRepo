//
//  NetworkManager.swift
//  SearchGithubRepo
//
//  Created by KyeongKyu Lee on 2023/02/16.
//

import Foundation

class NetworkManager: NSObject {
    
    static let sharedInstance: NetworkManager = {
        return NetworkManager()
    }()
    
    override init() {
    }
    
    func searchRepoList(_ search: GitHubSearchRepoList, completion: @escaping ((Result<SearchRepoResponse, Error>) -> Void)) {
        guard let request = search.createRequest() else { return }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 30
        config.httpAdditionalHeaders = ["Accept": "application/vnd.github.v3+json"]
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("data not found")
                return
            }
            do {
                let response = try self.decode(data)
                completion(.success(response))
            } catch {
                print("decoding error: ", error.localizedDescription)
                
            }
        }
        task.resume()
    }
    
    func decode(_ data: Data) throws -> SearchRepoResponse {
        
        return try JSONDecoder().decode(SearchRepoResponse.self, from: data)
    }
}

// REST API 문서 : https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-repositories
// MARK: - GitHubSearchRepoList
struct GitHubSearchRepoList {
    
    let baseURL = "https://api.github.com"
    let path = "/search/repositories"
    var searchQuery: String
    var sortOption: GitHubSortOption?
    var isDescending: Bool?
    var resultsPerPage: UInt8?
    var numPages: UInt?
    
    func createRequest() -> URLRequest? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        components.path = path
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: searchQuery))
        if let sortOption = sortOption {
            queryItems.append(URLQueryItem(name: "sort", value: sortOption.rawValue))
        }
        if let isDescending = isDescending {
            queryItems.append(URLQueryItem(name: "order", value: isDescending ? "desc" : "asc"))
        }
        if let resultsPerPage = resultsPerPage, let numPages = numPages {
            queryItems.append(URLQueryItem(name: "per_page", value: String(resultsPerPage)))
            queryItems.append(URLQueryItem(name: "page", value: String(numPages)))
        } else {
            queryItems.append(URLQueryItem(name: "per_page", value: "100"))
            queryItems.append(URLQueryItem(name: "page", value: "1"))
        }
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}

enum GitHubSortOption: String, CaseIterable {
    case stars               = "stars"
    case forks               = "forks"
    case help_wanted_issues  = "help-wanted-issues"
    case updated             = "updated"
}

