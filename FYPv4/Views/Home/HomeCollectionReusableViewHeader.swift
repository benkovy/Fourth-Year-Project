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
        if let weekday = Date.dayOfTheWeek(plusOffset: 0) {
            self.topLabel.text = weekday
        }
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 32
        self.topLabel.setFontTo(style: .title)
        self.bottomLabel.setFontTo(style: .name)
        if let routine = UserDefaultsStore.retrieve(Routine.self), let day = Date.intDay() {
            self.bottomLabel.text = routine.days[day - 1].initialized?
                .joined(separator: " | ")
                .capitalized
                ?? "No workout scheduled"
        } else {
            self.bottomLabel.text = "No workout scheduled"
        }
    }
}

extension Date {
    static func intDay() -> Int? {
        let date = Date()
        guard let day = Calendar.current.date(byAdding: .day, value: 0, to: date) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: day)
        return weekDay
    }
}
