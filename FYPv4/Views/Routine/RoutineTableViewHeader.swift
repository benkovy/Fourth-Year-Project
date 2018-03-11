//
//  RoutineTableViewHeader.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-10.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class RoutineTableViewHeader: UIView {

    var headerMainLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setFontTo(style: .title)
        return view
    }()
    
    var headerWorkoutType: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setFontTo(style: .paragraph)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerMainLabel)
        addSubview(headerWorkoutType)
        self.configureHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RoutineTableViewHeader {
    func configureHeader() {
        backgroundColor = .white
        headerMainLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerMainLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        headerWorkoutType.topAnchor.constraint(equalTo: self.headerMainLabel.bottomAnchor, constant: 6).isActive = true
        headerWorkoutType.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        headerWorkoutType.text = "Workout type not specified"
    }
}
