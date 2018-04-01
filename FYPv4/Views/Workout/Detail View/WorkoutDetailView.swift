//
//  WorkoutDetailView.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-04-01.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class WorkoutDetailView: UIViewController, TableViewDelegatable {

    @IBOutlet weak var tableView: UITableView!
    
    let workout: WebWorkout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tableView.roundCorners(by: 12)
        delegateTableView()
        tableView.register(WorkoutDetailViewTableViewCell.self)
        tableView.register(MovementDetailViewTableViewCell.self)
        style()
    }
    
    init(workout: WebWorkout) {
        self.workout = workout
        super.init(nibName: WorkoutDetailView.nibName, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
    }
}

extension WorkoutDetailView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0)
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0)
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WorkoutDetailViewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: workout)
            return cell
        case 1:
            let cell: MovementDetailViewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            guard let movement = workout.movements?[indexPath.row] else {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                return cell
            }
            cell.configure(with: movement)
            return cell
        default:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return workout.movements?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
            guard let cell = tableView.cellForRow(at: indexPath) as? MovementDetailViewTableViewCell else {
                return 0
            }
            return cell.mDescription.isHidden ? 60 : 165
        default:
            return 0
        }
    }
}
