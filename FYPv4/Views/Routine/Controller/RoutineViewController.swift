//
//  RoutineViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-24.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class RoutineViewController: UIViewController, TableViewDelegatable {

    @IBOutlet weak var tableView: UITableView!
    
    var viewState: RoutineViewState = .noroutine
    
    let webservice: WebService
    var storedOffsets = [Int: CGFloat]()
    var routine: Routine?
    
    init(webservice: WebService, routine: Routine?) {
        self.webservice = webservice
        if routine == nil {
            self.routine = Routine()
        } else {
            self.routine = routine
        }
        super.init(nibName: RoutineViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegateTableView()
        self.tableView.register(RoutineTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureUI(.regularWhite)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMovement))
        add.tintColor = .gray
        navigationItem.setRightBarButton(add, animated: true)
    }
    
    func stateRoutine() {
        if let user = UserDefaultsStore.retrieve(User.self) {
            if user.userType() == "ACC" {
                // Network get routine
                // on error check store
            } else {
                // check store
            }
        }
    }
        
}

extension RoutineViewController: UserAuthDelegatable { }

extension RoutineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(workout: Workout(name: "THIS WORKOUT", creator: "Ben Kovacs", creatorName: "Ben Kovacs", time: 32, description: "BLAH", image: true, rating: 324, id: "asdasdasd"))
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 170)
    }
    
}

extension RoutineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableCell = cell as? RoutineTableViewCell else { return }
        storedOffsets[indexPath.section] = tableCell.collectionviewOffset
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let num = self.routine?.days.count else { return 7 }
        return num
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RoutineTableViewHeader()
        if let weekday = Date.dayOfTheWeek(plusOffset: section) {
            headerView.headerMainLabel.text = weekday
        }
        
        headerView.moreButton.tag = section
        headerView.moreButton.addTarget(self, action: #selector(moreButtonPress), for: .touchUpInside)
        
        switch getTableViewCellType(indexPath: IndexPath(row: 0, section: section)) {
        case .empty:
            headerView.headerWorkoutType.text = "No workout type specified"
        case .finalized:
            guard let r = self.routine else { return headerView }
            headerView.headerWorkoutType.text = r.days[section].initialized?.capitalized ?? "No workout type specified"
        case .initialized:
            guard let r = self.routine else { return headerView }
            headerView.headerWorkoutType.text = r.days[section].initialized?.capitalized ?? "No workout type specified"
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = false
        view.layer.masksToBounds = false
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: RoutineTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        switch getTableViewCellType(indexPath: indexPath) {
        case .empty:
            cell.collectionView.isHidden = true
            cell.chooseType.isHidden = false
            cell.selectionStyle = .gray
        case .finalized:
            cell.collectionView.isHidden = false
            cell.chooseType.isHidden = true
            cell.selectionStyle = .none
        case .initialized:
            cell.collectionView.isHidden = false
            cell.chooseType.isHidden = true
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch getTableViewCellType(indexPath: indexPath) {
        case .empty:
            return 100
        case .finalized:
            return 220
        case .initialized:
            return 220
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? RoutineTableViewCell else { return }
        cell.chooseType.isHidden = true
        if let weekday = Date.dayOfTheWeek(plusOffset: indexPath.section) {
            let vc = ModalWorkoutTypeViewController(delegate: self, day: weekday, indexPath: indexPath)
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? RoutineTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
        tableViewCell.collectionviewOffset = storedOffsets[indexPath.section] ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension RoutineViewController: ModalDelegatable {
    
    func modalPassingBack(value: WorkoutType, forCellAt: IndexPath) {
        guard var r = self.routine else { return }
        r.initializeDay(number: forCellAt.section, toValue: String(describing: value))
        routine = r
        UserDefaultsStore.store(persistables: r)
        tableView.reloadData()
    }
    
    func modalDidCancel(forCellAt: IndexPath) {
        guard let cell = tableView.cellForRow(at: forCellAt) as? RoutineTableViewCell else { return }
        cell.chooseType.isHidden = false
    }
}

extension RoutineViewController {
    
    @objc func handleNewMovement() {
        print("Add")
    }
    
    @objc func handleOptionOne() {
        tabBarController?.selectedIndex = 2
    }
    
    @objc func handleOptionTwo() {
        tableView.isHidden = false
        
    }
    
    @objc func moreButtonPress(_ sender: UIButton) {
        print(sender.tag)
    }
    
    func getTableViewCellType(indexPath: IndexPath) -> WorkoutDay {
        guard let r = self.routine else { return .empty }
        return r.dayType(forDay: indexPath.section)
    }
    
    @objc func chooseWorkoutButtonPress(sender: UIButton) {
        
    }
}