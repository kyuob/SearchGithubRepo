//
//  ReuseableCell.swift
//  SearchGithubRepo
//
//  Created by KyeongKyu Lee on 2023/02/17.
//

import Foundation

protocol ReusableCell {
    associatedtype T
    var viewData: T? { get set }
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        String(describing: String(describing: self))
    }
}
