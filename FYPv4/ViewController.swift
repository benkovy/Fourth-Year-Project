//
//  ViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-10.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var ref: Database = {
        return Database()
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        let movements = Movement(name: "New name", bodyPart: .chest, sets: 4, reps: 10, restTime: 45)
//        let workout = Workout(id: "12345", movements: movements, dateCreated: 1, popularity: 4)
//        ref.persist(workout)
//        ref.update(workout)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

