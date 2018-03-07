//
//  HomeCollectionViewCell.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-06.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var imageViewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension HomeCollectionViewCell {
    func configureCell(workout: Workout) {
        self.layer.masksToBounds = false
        self.imageViewContainer.roundCorners(by: 16)
        self.imageViewContainer.layer.masksToBounds = true
        self.workoutImage.contentMode = .scaleAspectFit
        self.workoutImage.backgroundColor = .black
        self.workoutName.setFontTo(style: .title)
        self.workoutName.text = workout.name
        self.mainContentView.layer.applySketchShadow(color: .black, alpha: 0.15, x: -2, y: 9, blur: 22, spread: 0)
        self.mainContentView.roundCorners(by: 16)
        
    }
}
