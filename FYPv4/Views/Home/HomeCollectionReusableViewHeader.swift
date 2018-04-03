//
//  HomeCollectionReusableViewHeader.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-07.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
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
        if let user = UserDefaultsStore.retrieve(User.self), let imgString = user.image {
            if let data = Data(base64Encoded: imgString) {
                imageView.image = UIImage(data: data)
            }
        } else {
            let num = Int.randRange(lower: 1, upper: 4)
            self.imageView.image = UIImage(named: "t\(num)")
        }
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 32
        self.topLabel.setFontTo(style: .title)
        self.bottomLabel.setFontTo(style: .name)
        self.topLabel.text = "Today"
        self.bottomLabel.text = Date.now(withFormat: "dd.MM.yyyy")
    }
}
