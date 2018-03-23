//
//  MovementTableViewCell.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-21.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class MovementTableViewCell: UITableViewCell {

    @IBOutlet weak var mainCellView: UIView!
    @IBOutlet weak var movementName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        self.movementName.setFontTo(style: .movementCell)
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.masksToBounds = false
        self.mainCellView.layer.masksToBounds = false
        self.contentView.backgroundColor = .clear
        self.mainCellView.clipsToBounds = false
        self.mainCellView.roundCorners(by: 12)
        self.mainCellView.layer.applySketchShadow(color: .black, alpha: 0.3, x: -2, y: 5, blur: 12, spread: 0)
    }
}
