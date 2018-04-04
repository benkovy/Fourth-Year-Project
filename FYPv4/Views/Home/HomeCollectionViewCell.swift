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
    @IBOutlet weak var creatorName: UILabel!
    @IBOutlet weak var worked: UILabel!
    @IBOutlet weak var movement1: UILabel!
    @IBOutlet weak var movement2: UILabel!
    @IBOutlet weak var movement3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageViewContainer.sizeToFit()
        self.workoutImage.contentMode = .scaleToFill
        self.workoutImage.layer.masksToBounds = true
        // Initialization code
    }

}

extension HomeCollectionViewCell {
    func configureCell(workout: Workout) {
        self.layer.masksToBounds = false
        self.imageViewContainer.roundCorners(by: 16)
        self.imageViewContainer.layer.masksToBounds = true
        self.workoutName.setFontTo(style: .title)
        self.creatorName.setFontTo(style: .name)
        self.worked.setFontTo(style: .name)
        self.worked.text = "\(workout.tags.joined(separator: " | "))"
        self.workoutName.text = workout.name
        self.creatorName.text = workout.creatorName
        self.mainContentView.layer.applySketchShadow(color: .black, alpha: 0.15, x: -2, y: 9, blur: 22, spread: 0)
        self.mainContentView.roundCorners(by: 16)
    }
    
    func configureCellWithMovements(workout: WebWorkout, image: UIImage?) {
        
        if image == nil {
            let num = Int.randRange(lower: 1, upper: 4)
            self.workoutImage.image = UIImage(named: "t\(num)")
        } else if let img = image {
            workoutImage.image = img
        }
        self.layer.masksToBounds = false
        self.imageViewContainer.roundCorners(by: 16)
        self.imageViewContainer.layer.masksToBounds = true
        self.workoutName.setFontTo(style: .title)
        self.creatorName.setFontTo(style: .name)
        self.worked.setFontTo(style: .name)
        self.worked.text = "Worked: \(workout.rating)"
        self.workoutName.text = workout.name
        self.creatorName.text = workout.creatorName
        self.mainContentView.layer.applySketchShadow(color: .black, alpha: 0.15, x: -2, y: 9, blur: 22, spread: 0)
        self.mainContentView.roundCorners(by: 16)
        self.movement1.setFontTo(style: .header)
        self.movement2.setFontTo(style: .header)
        self.movement3.setFontTo(style: .header)
        guard let m = workout.movements else { return }
        if m.count >= 3 {
            movement1.text = labelForMovement(movement: m[0])
            movement2.text = labelForMovement(movement: m[1])
            movement3.text = labelForMovement(movement: m[2])
        } else if m.count == 2 {
            movement1.text = labelForMovement(movement: m[0])
            movement2.text = labelForMovement(movement: m[1])
            movement3.text = ""
        } else if m.count == 1 {
            movement1.text = labelForMovement(movement: m[0])
            movement2.text = ""
            movement3.text = ""
        } else {
            movement1.text = "No Movements!?!"
            movement2.text = ""
            movement3.text = ""
        }
    }
    
    func labelForMovement(movement: Movement) -> String {
        return "\(movement.name) \(movement.sets) x \(movement.reps)"
    }
}
