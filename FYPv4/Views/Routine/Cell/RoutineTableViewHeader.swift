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
        view.setFontTo(style: .routineHeaderTitle)
        return view
    }()
    
    var errorLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setFontTo(style: .paragraph)
        view.textColor = .red
        return view
    }()
    
    let check: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "markCheck"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let arrow: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "arrow"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.peakBlue.withAlphaComponent(0.6)
        return view
    }()
    
    var headerWorkoutType: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setFontTo(style: .paragraph)
        return view
    }()
    
    var sideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var moreButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        let color = UIColor.peakBlue.withAlphaComponent(0.6)
        view.styleSmallButtonFYP(withTitle: "Edit", textColor: .white, bg: color)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(check)
        addSubview(titleBackground)
        addSubview(headerMainLabel)
        addSubview(headerWorkoutType)
        addSubview(arrow)
        addSubview(moreButton)
        addSubview(errorLabel)
        self.configureHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RoutineTableViewHeader {
    func configureHeader() {
        backgroundColor = .white
//        sideView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        sideView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        sideView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        sideView.widthAnchor.constraint(equalToConstant: 8).isActive = true
//        sideView.backgroundColor = UIColor.peakBlue
        
        headerMainLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerMainLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        
        titleBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -8).isActive = true
        titleBackground.heightAnchor.constraint(equalTo: headerMainLabel.heightAnchor, constant: 2).isActive = true
        titleBackground.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleBackground.widthAnchor.constraint(equalTo: headerMainLabel.widthAnchor, constant: 28).isActive = true
        
        check.leftAnchor.constraint(equalTo: titleBackground.rightAnchor, constant: 12).isActive = true
        check.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        check.isHidden = true
        
        headerWorkoutType.topAnchor.constraint(equalTo: self.headerMainLabel.bottomAnchor, constant: 6).isActive = true
        headerWorkoutType.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        headerWorkoutType.text = "Workout type not specified"
        
        errorLabel.topAnchor.constraint(equalTo: self.headerMainLabel.bottomAnchor, constant: 6).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        errorLabel.text = ""
        errorLabel.textAlignment = .right
        
        moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        moreButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        
        arrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        arrow.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 4).isActive = true
        titleBackground.roundCorners(by: 4)
    }
}
