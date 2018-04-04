//
//  WorkoutDetailViewTableViewCell.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-04-01.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class WorkoutDetailViewTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageWorkout: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var wDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    func style() {
        imageViewContainer.roundCorners(by: 20)
        imageViewContainer.clipsToBounds = false
        imageViewContainer.layer.masksToBounds = false
        imageViewContainer.layer.applySketchShadow(color: .black, alpha: 0.15, x: -2, y: 9, blur: 22, spread: 0)
        imageWorkout.roundCorners(by: 20)
        imageWorkout.backgroundColor = .black
        name.setFontTo(style: .title)
        creator.setFontTo(style: .name)
        wDescription.setFontTo(style: .header)
        imageWorkout.contentMode = .scaleAspectFill
        imageWorkout.layer.masksToBounds = true
    }
    
    func configure(with workout: WebWorkout, image: UIImage?) {
        if let img = image {
            imageWorkout.image = img
        } else {
            imageWorkout.image = UIImage(named: "t\(Int.randRange(lower: 1, upper: 4))")
        }
        name.text = workout.name
        creator.text = workout.creatorName
        wDescription.text = workout.description
    }
}
