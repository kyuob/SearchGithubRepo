//
//  SearchViewController.swift
//  SearchGithubRepo
//
//  Created by KyeongKyu Lee on 2023/02/16.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupViewModel() {
        viewModel.reloadSearchResultsTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.searchResultsTableView.reloadData()
            }
        }
        viewModel.loadingRepoList = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
            }
        }
        viewModel.finishedLoading = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    private func setupSubviews() {
        searchResultsTableView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.reuseIdentifier)
        
        view.addSubview(activityIndicator)
        
        let activityIndicatorYPositionFromTop: CGFloat = self.view.bounds.height/2
        let activityIndicatorWidth: CGFloat = 40
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.topAnchor,
                                                       constant: activityIndicatorYPositionFromTop),
            activityIndicator.widthAnchor.constraint(equalToConstant: activityIndicatorWidth)
        ])
    }
    
    
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.reuseIdentifier, for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        let item = viewModel.repoArray[indexPath.row]
        cell.viewData = ResultViewData(name: item.repo_name)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.repoArray[indexPath.row]
        if let url = item.repo_url {
            UIApplication.shared.open(url)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return true }
        viewModel.loadRepoList(searchQuery: text)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clearData()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        guard let text = textField.text else { return true }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        viewModel.loadRepoList(searchQuery: newString)
        return true
    }
}
