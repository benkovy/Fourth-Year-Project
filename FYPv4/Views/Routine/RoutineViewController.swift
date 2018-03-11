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
    
    var noRoutineView: NoRoutineUIView = {
        let view = NoRoutineUIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noRoutineView)
        noRoutineView.delegate = self
        self.delegateTableView()
        tableView.separatorStyle = .none
        self.tableView.register(RoutineTableViewCell.self)
        self.tableView.backgroundColor = .white
        self.handleViewState()
        self.configureViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureUI(.regularWhite)
        self.title = "Routine"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMovement))
        add.tintColor = .gray
        navigationItem.setRightBarButton(add, animated: true)
        self.handleViewState()
    }
    
    func handleViewState() {
        if self.userIsAuthenticated() {
            if let routine = UserDefaultsStore.retrieve(Routine.self) {
                // display users routine
                noRoutineView.isHidden = true
                tableView.isHidden = false
                
                if routine.isDaybyDay {
                    self.viewState = .daybyday
                } else if routine.isCustom {
                    self.viewState = .custom
                }
            
            } else {
                // display create routine view
                tableView.isHidden = true
                noRoutineView.isHidden = false
                self.viewState = .noroutine
            }
            
        } else {
            // display create routine view
            tableView.isHidden = true
            noRoutineView.isHidden = false
            self.viewState = .noroutine
        }
        self.tableView.reloadData()
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
        switch self.viewState {
        case .custom:
            print("custom")
            return 2
        case .daybyday:
            return 7
        case .noroutine:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RoutineTableViewHeader()
        if let weekday = Date.dayOfTheWeek(plusOffset: section) {
            headerView.headerMainLabel.text = weekday
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: RoutineTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.layer.masksToBounds = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
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

extension RoutineViewController: NoRoutineActionDelegate {
    
    @objc func handleNewMovement() {
        print("Add")
    }
    
    @objc func handleOptionOne() {
        tabBarController?.selectedIndex = 2
    }
    
    @objc func handleOptionTwo() {
        let vc = RoutineChoiceViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureViewConstraints() {
        noRoutineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        noRoutineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        noRoutineView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        noRoutineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        noRoutineView.titleMessage.centerXAnchor.constraint(equalTo: noRoutineView.centerXAnchor).isActive = true
        noRoutineView.titleMessage.centerYAnchor.constraint(equalTo: noRoutineView.centerYAnchor, constant: -100).isActive = true
        noRoutineView.titleMessage.text = "No Routines"
        if !self.userIsAuthenticated() {
            noRoutineView.optionOne.topAnchor.constraint(equalTo: noRoutineView.titleMessage.bottomAnchor, constant: 20).isActive = true
            noRoutineView.optionOne.centerXAnchor.constraint(equalTo: noRoutineView.centerXAnchor).isActive = true
            noRoutineView.or.centerXAnchor.constraint(equalTo: noRoutineView.centerXAnchor).isActive = true
            noRoutineView.or.topAnchor.constraint(equalTo: noRoutineView.optionOne.bottomAnchor, constant: 20).isActive = true
            noRoutineView.or.text = "Or"
            noRoutineView.optionTwo.topAnchor.constraint(equalTo: noRoutineView.or.bottomAnchor, constant: 20).isActive = true
            noRoutineView.optionTwo.centerXAnchor.constraint(equalTo: noRoutineView.centerXAnchor).isActive = true
        } else {
            noRoutineView.optionOne.isHidden = true
            noRoutineView.optionTwo.topAnchor.constraint(equalTo: noRoutineView.titleMessage.bottomAnchor, constant: 20).isActive = true
            noRoutineView.optionTwo.centerXAnchor.constraint(equalTo: noRoutineView.centerXAnchor).isActive = true
        }
        noRoutineView.optionOne.addTarget(self, action: #selector(handleOptionOne), for: .touchUpInside)
        noRoutineView.optionTwo.addTarget(self, action: #selector(handleOptionTwo), for: .touchUpInside)
    }
}
