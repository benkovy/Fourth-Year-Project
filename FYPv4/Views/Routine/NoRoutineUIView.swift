//
//  NoRoutineUIView.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-08.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class NoRoutineUIView: UIView {
    
    weak var delegate: NoRoutineActionDelegate?

    let titleMessage: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let or: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var optionOne: UIButton = {
        let view = UIButton(type: .system)
        view.styleButtonFYP(withTitle: "Sign In")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var optionTwo: UIButton = {
        let view = UIButton(type: .system)
        view.styleButtonFYP(withTitle: "Create Routine")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleMessage)
        self.addSubview(or)
        self.addSubview(optionOne)
        self.addSubview(optionTwo)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension NoRoutineUIView: ViewConfigurable {
    func configureView() {
        titleMessage.setFontTo(style: .title)
        or.setFontTo(style: .title)
    }
}

