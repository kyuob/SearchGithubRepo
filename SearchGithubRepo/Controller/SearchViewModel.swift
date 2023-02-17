//
//  SearchViewModel.swift
//  SearchGithubRepo
//
//  Created by KyeongKyu Lee on 2023/02/17.
//

import UIKit

class SearchViewModel {
    var repoArray: [RepoModel] = [] {
        willSet {
            self.reloadSearchResultsTableView?()
        }
    }
    var reloadSearchResultsTableView: (() -> Void)?
    var loadingRepoList: (() -> Void)?
    var finishedLoading: (() -> Void)?
    let searchQueue = DispatchQueue(label: "searchQueue", qos: .userInteractive, attributes: .concurrent)
    var searchTask: DispatchWorkItem?
    var shouldCancelTask: Bool = false
    let throttleInterval: TimeInterval = 0.5
    
    func loadRepoList(searchQuery: String) {
        self.searchTask?.cancel()
        self.loadingRepoList?()
        
        let task = DispatchWorkItem { [weak self] in
            self?.loadRepoTask(searchQuery)
        }
        self.searchTask = task
        
        searchQueue.asyncAfter(deadline: .now() + throttleInterval, execute: task)
    }
    
    private func loadRepoTask(_ searchQuery: String) {
        let search = GitHubSearchRepoList(searchQuery: searchQuery)
        let client = NetworkManager.sharedInstance
        shouldCancelTask = false
        client.searchRepoList(search) { [weak self] result in
            guard let self = self else { return }
            guard !self.shouldCancelTask else { return }
            switch result {
            case .success(let response):
                self.repoArray = response.items.map {
                    RepoModel(repo_name: $0.full_name,
                         repo_url: URL(string: $0.html_url)) }
                self.finishedLoading?()
            case .failure(let error):
                print("error in result: \(error) \(error.localizedDescription)")
                self.finishedLoading?()
            }
        }
    }
    
    func clearData() {
        self.finishedLoading?()
        self.repoArray = []
        self.shouldCancelTask = true
        self.searchTask?.cancel()
    }
}


