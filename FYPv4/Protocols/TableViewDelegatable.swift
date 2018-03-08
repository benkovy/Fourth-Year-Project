//
//  TableViewDelegatable.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-07.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewDelegatable {
    var tableView: UITableView! { get set }
}

extension TableViewDelegatable where Self: UITableViewDataSource & UITableViewDelegate {
    func delegateTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
