//
//  HomeCollectionReusableViewHeader.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-07.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class HomeCollectionReusableViewHeader: UICollectionReusableView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension HomeCollectionReusableViewHeader {
    func configure() {
        self.imageView.backgroundColor = .black
        self.imageView.layer.cornerRadius = 32
        self.topLabel.setFontTo(style: .title)
        self.bottomLabel.setFontTo(style: .name)
        self.topLabel.text = "Today"
        self.bottomLabel.text = Date.now(withFormat: "dd.MM.yyyy")
    }
}
