//
//  MovementDetailViewTableViewCell.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-04-01.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class MovementDetailViewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var repsAndSets: UILabel!
    @IBOutlet weak var mDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    func style() {
        name.setFontTo(style: .title)
        repsAndSets.setFontTo(style: .repsAndSets)
        mDescription.setFontTo(style: .header)
        self.layer.masksToBounds = true
    }
    
    func configure(with movement: Movement) {
        name.text = movement.name
        repsAndSets.text = "\(movement.sets) sets of \(movement.reps) reps | \(String.getTime(row: movement.restTime)) rest"
        mDescription.text = movement.description
    }
}
