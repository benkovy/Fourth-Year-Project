//
//  CreateWorkoutViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-20.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class CreateWorkoutViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movementsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
    }
}

extension CreateWorkoutViewController {
    func configureViews() {
        movementsLabel.setFontTo(style: .inputLabel)
        movementsLabel.text = "Movements"
        nameLabel.setFontTo(style: .inputLabel)
        nameLabel.text = "Give your workout a name"
    }
}
