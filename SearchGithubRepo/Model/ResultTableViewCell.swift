//
//  ResultTableViewCell.swift
//  SearchGithubRepo
//
//  Created by KyeongKyu Lee on 2023/02/17.
//

import UIKit

struct ResultViewData {
    let name: String
}

class ResultTableViewCell: UITableViewCell, ReusableCell {
    typealias T = ResultViewData
    var viewData: ResultViewData? {
        willSet {
            self.textLabel?.text = newValue?.name
        }
    }
}
