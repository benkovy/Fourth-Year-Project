//
//  RoutineViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-24.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class RoutineViewController: UIViewController, TableViewDelegatable, ErrorViewDelegate {
    var errorView: ErrorView?
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewState: RoutineViewState = .noroutine
    
    let webservice: WebService
    var storedOffsets = [Int: CGFloat]()
    var routine: Routine?
    
    init(webservice: WebService) {
        self.webservice = webservice
        self.routine = Routine()
        super.init(nibName: RoutineViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegateTableView()
        self.tableView.register(RoutineTableViewCell.self)
        tableView.reloadData()
        errorView = ErrorView(frame: CGRect(x: 0, y: -40, width: self.view.frame.width, height: 40))
        setupErrorView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureUI(.regularWhite)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewWorkout))
        add.tintColor = .gray
        navigationItem.setRightBarButton(add, animated: true)
        self.stateRoutine()
    }
    
    func stateRoutine() {
        if let user = UserDefaultsStore.retrieve(User.self) {
            if user.userType() == "ACC" {
                errorView?.callError(withTitle: "Retrieving routine", andColor: UIColor.peakBlue)
                self.getRoutine(user: user) { (result) in
                    switch result {
                    case .error(_):
                        DispatchQueue.main.async {
                            self.errorView?.callError(withTitle: "Routine couldn't be retrieved", andColor: .red)
                        }
                    case .success(let routine):
                        self.routine = routine
                        DispatchQueue.main.async {
                            self.errorView?.callError(withTitle: "Routine is up to date", andColor: UIColor.peakBlue)
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                if let r = getRoutineFromStore() {
                    routine = r
                }
            }
        } else {
            tableView.reloadData()
        }
    }
}

extension RoutineViewController: UserAuthDelegatable { }

extension RoutineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch getTableViewCellType(indexPath: collectionView.tag) {
        case .empty:
            return 0
        case .finalized:
            return 1
        case .initialized:
            guard let r = self.routine else { return 0 }
            return r.days[collectionView.tag].finalized?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        switch getTableViewCellType(indexPath: collectionView.tag) {
        case .empty:
            cell.configureCell(workout: Workout(name: "THIS WORKOUT", creator: "Ben Kovacs", creatorName: "Ben Kovacs", time: 32, description: "BLAH", image: true, rating: 324, id: "asdasdasd", tags: ["dadada"]))
        case .finalized:
            if let workout = self.routine?.days[collectionView.tag].finalized?.first {
                cell.configureCellWithMovements(workout: workout)
            } else {
                cell.configureCell(workout: Workout(name: "", creator: " ", creatorName: " ", time: 32, description: "", image: true, rating: 0, id: "", tags: ["dadada"]))
            }
        case .initialized:
            guard let r = self.routine, let w = r.days[collectionView.tag].finalized?[indexPath.row] else {
                cell.configureCell(workout: Workout(name: "", creator: " ", creatorName: " ", time: 32, description: "", image: true, rating: 0, id: "", tags: ["dadada"]))
                return cell
            }
            cell.configureCellWithMovements(workout: w)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let r = self.routine, let workout = r.days[collectionView.tag].finalized?[indexPath.row] else { return }
        print(workout)
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
            headerView.check.isHidden = true
        case .finalized:
            guard let r = self.routine else { return headerView }
            headerView.headerWorkoutType.text = r.days[section].initialized?.joined(separator: " | ").capitalized ?? "No workout type specified"
            headerView.check.isHidden = false
        case .initialized:
            guard let r = self.routine else { return headerView }
            let types = r.days[section].initialized?.joined(separator: " | ").capitalized ?? "No workout type specified"
            if r.days[section].finalized?.count == 0 {
                headerView.errorLabel.text = "No workouts for: \(types)"
            } else {
                headerView.errorLabel.text = ""
            }
            headerView.headerWorkoutType.text = types
            headerView.check.isHidden = true
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
            guard let r = self.routine, r.days[indexPath.section].finalized?.count != 0 else {
                return 100
            }
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
        r.initializeDay(number: forCellAt.section, toValue: [String(describing: value)])
        routine = r
        if let user = UserDefaultsStore.retrieve(User.self) {
            self.saveRoutine(user: user) { (result) in
                switch result {
                case .error(let error):
                    print("error: \(error)")
                case .success(let routine):
                    DispatchQueue.main.async {
                        self.errorView?.callError(withTitle: "Routine updated", andColor: UIColor.peakBlue)
                        self.routine = routine
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            self.tableView.reloadData()
        }
        
    }
    
    func modalDidCancel(forCellAt: IndexPath) {
        guard let cell = tableView.cellForRow(at: forCellAt) as? RoutineTableViewCell else { return }
        cell.chooseType.isHidden = false
    }
}

extension RoutineViewController {
    
    @objc func handleNewWorkout() {
        let vc = CreateWorkoutViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleOptionOne() {
        tabBarController?.selectedIndex = 2
    }
    
    @objc func handleOptionTwo() {
        tableView.isHidden = false
    }
    
    @objc func moreButtonPress(_ sender: UIButton) {
        let vc = EditMenuViewController(delegate: self, forDay: sender.tag)
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func getTableViewCellType(indexPath: IndexPath) -> WorkoutDay {
        guard let r = self.routine else { return .empty }
        return r.dayType(forDay: indexPath.section)
    }
    
    func getTableViewCellType(indexPath: Int) -> WorkoutDay {
        guard let r = self.routine else { return .empty }
        return r.dayType(forDay: indexPath)
    }
    
    @objc func chooseWorkoutButtonPress(sender: UIButton) {
        
    }
    
    func hasToken(user: User) -> Bool {
        return user.userHasToken()
    }
    
    func saveRoutine(user: User, callback: @escaping (Result<Routine>) -> ()) {
        if self.hasToken(user: user) {
            guard let token = user.token, var r = self.routine, let id = user.id else { return }
            r.setUserId(id: id)
            UserDefaultsStore.store(persistables: r)
            User.saveUserRoutine(webservice: webservice, token: token, routine: r, callback: { result in
                guard let res = result else { callback(Result(nil,or: "")); return }
                callback(res)
            })
        } else {
            guard let r = self.routine else {return}
            UserDefaultsStore.store(persistables: r)
            tableView.reloadData()
        }
        self.tableView.reloadData()
    }
    
    func getRoutineFromStore() -> Routine? {
        return UserDefaultsStore.retrieve(Routine.self)
    }
    
    func getRoutine(user: User, callback: @escaping (Result<Routine>) -> ()) {
        if self.hasToken(user: user) {
            guard let user = UserDefaultsStore.retrieve(User.self), let token = user.token else { return }
            User.userRoutine(webservice: webservice, token: token, callback: { result in
                guard let res = result else { callback(Result(nil,or: "")); return}
                callback(res)
            })
        } else {
            callback(Result(self.getRoutineFromStore(), or: ""))
        }
    }
}

extension RoutineViewController: EditMenuDelegatable {
    func menuDidRequestClear(forDay: Int) {
        guard var r = self.routine else { return }
        r.emptyDay(number: forDay)
        routine = r
        if let user = UserDefaultsStore.retrieve(User.self) {
            self.saveRoutine(user: user) { (result) in
                switch result {
                case .error(let error):
                    print("error: \(error)")
                case .success(let routine):
                    self.routine = routine
                    DispatchQueue.main.async {
                        self.errorView?.callError(withTitle: "Routine updated", andColor: UIColor.peakBlue)
                    }
                }
            }
        }
    }
    
    func menuDidRequestAdd(value: [String : Any], forDay: Int) {
        // add type
    }
}
