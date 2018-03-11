//
//  RoutineChoiceViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-08.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class RoutineChoiceViewController: UIViewController {
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var optionOneDescription: UITextView!
    @IBOutlet weak var optionTwoDiscription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem?.tintColor = .lightGray
    }
    
    @IBAction func handleDayByDay(_ sender: UIButton) {
        guard let user = UserDefaultsStore.retrieve(User.self) else { return }
        guard let userId = user.id, let userName = user.fullName else { return }
        let routine = Routine(ownerId: userId, ownerName: userName, name: "Choose a Name", isDaybyDay: true, dayByDay: DayByDay(), isCustom: false, custom: nil, id: nil)
        UserDefaultsStore.store(persistables: routine)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handelCreateCustom(_ sender: UIButton) {
        
    }
}

extension RoutineChoiceViewController {
    func configureViews() {
        buttonOne.styleButtonFYP(withTitle: "Create Custom Routine")
        buttonTwo.styleButtonFYP(withTitle: "Day by Day")
        optionOneDescription.setFontTo(style: .paragraph)
        optionTwoDiscription.setFontTo(style: .paragraph)
        optionOneDescription.text = "A day by day routine lets you define your upcoming week of workouts. In your routine page, there will be a spot for each of the next 7 days. It is up to you to define what you would like to workout on that particular day. Once this has been chosen you will be able to pick from a variety of interesting workouts!"
        optionTwoDiscription.text = "Creating a custom routine allows you to pre define your workouts. Maybe you are doing a push pull legs split, or the bro split. This options hopes to accomodate more complex routines and programs."
        
    }
}
