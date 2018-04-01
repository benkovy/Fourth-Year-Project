//
//  CreateWorkoutViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-20.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class CreateWorkoutViewController: UIViewController, TableViewDelegatable, MovementDelegate, ErrorViewDelegate {
    var errorView: ErrorView?
    
    @IBOutlet weak var tableView: UITableView!
    
    let webservice = WebService()
    var movements: [Movement?] = []
    var tags: [String] = []
    let maxMovements = 15
    var num = 0
    var name: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Workout"
        self.delegateTableView()
        tableView.register(InputTableViewCell.self)
        tableView.register(PickerTableViewCell.self)
        errorView = ErrorView(frame: CGRect(x: 0, y: -40, width: self.view.frame.width, height: 40))
        setupErrorView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let button = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(handleSubmit))
        navigationItem.setRightBarButton(button, animated: true)
    }
    
    @objc func addMovement(_ sender: UIButton) {
        movements.insert(nil, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        tableView.endUpdates()
    }
    
    func didFinishEditingMovement(movement: Movement, forIndex index: Int) {
        movements.remove(at: index)
        movements.insert(movement, at: index)
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
        tableView.endUpdates()
    }
    
    func cellLabel(forIndexPath indexPath: IndexPath) -> String {
        switch (indexPath.section, indexPath.row) {
        case (0,0): return "Name"
        case (0,1): return "Description"
        case (0,2): return "Image"
        case (0,3): return "Tags"
        default: return ""
        }
    }
}

extension CreateWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfLines(forIndexPath indexPath: IndexPath) -> Int {
        switch (indexPath.section, indexPath.row) {
        case (0,1): return 4
        default: return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 5
        case 1: return movements.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            guard let move = movements[indexPath.row] else {
                cell.textLabel?.text = "New Movement"
                return cell
            }
            cell.textLabel?.text = move.name
            return cell
        } else {
            if indexPath.row == 0 || indexPath.row == 1 {
                let cell: InputTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                
                // If there has already been something entered... re enter
                if indexPath.row == 1 && desc != nil {
                    cell.textView.text = self.desc
                } else if indexPath.row == 0 && name != nil {
                    cell.textView.text = self.name
                } else {
                    cell.textView.text = cellLabel(forIndexPath: indexPath)
                }
                
                cell.didRequestPlaceholder = { return self.cellLabel(forIndexPath: indexPath) }
                cell.didFinishEditing = { text in
                    if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        if text == "Name" { self.name = nil; return }
                        if text == "Description" { self.desc = nil; return }
                        if indexPath.row == 1 { self.desc = text }
                        if indexPath.row == 0 { self.name = text }
                    }
                }
                cell.textView.textContainer.maximumNumberOfLines = numberOfLines(forIndexPath: indexPath)
                cell.textView.textContainer.lineBreakMode = .byTruncatingTail
                return cell
            } else if indexPath.row == 4 {
                let cell: PickerTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.selectionStyle = .none
                cell.pickerView.tag = indexPath.row + indexPath.section
                cell.pickerView.selectRow(4, inComponent: 0, animated: true)
                cell.didRequestComponents = { return 1 }
                cell.didRequestRows = { return WorkoutType.allTypes.count }
                cell.didRequestTitles = { row in return String(describing: WorkoutType.allTypes[row]) }
                cell.didAddRow = { row in
                    let index =  IndexPath(row: 3, section: 0)
                    if !self.tags.contains(String(describing: WorkoutType.allTypes[row])) {
                        self.tags.append(String(describing: WorkoutType.allTypes[row]))
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [index], with: .none)
                        self.tableView.endUpdates()
                    }
                }
                cell.didRemoveRow = { row in
                    let path =  IndexPath(row: 3, section: 0)
                    if let index = self.tags.index(of: String(describing: WorkoutType.allTypes[row])) {
                        self.tags.remove(at: index)
                        self.tableView.reloadRows(at: [path], with: .none)
                    }
                }
                return cell
            } else {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.textLabel?.text = cellLabel(forIndexPath: indexPath)
                if indexPath.row == 3 {
                    cell.detailTextLabel?.text = tags.joined(separator: " | ")
                } else {
                    cell.detailTextLabel?.text = "Choose"
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,1): return 100
        case (0,4):
            guard let cell = tableView.cellForRow(at: indexPath) as? PickerTableViewCell else { return 0 }
            return cell.pickerView.isHidden ? 0 : 150
        default: return 44
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {return "Movements"}
        else {return ""}
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 28)
            let view = UIView(frame: frame)
            let label = UILabel(frame: CGRect(x: 16, y: 8, width: tableView.frame.width/2, height: 18))
            label.text = "Movements"
            label.setFontTo(style: .header)
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(addMovement(_:)), for: .touchUpInside)
            button.setTitle("Add", for: .normal)
            view.addSubview(button)
            view.addSubview(label)
            button.frame = CGRect(x: tableView.frame.width - 50, y: 8, width: 40, height: 18)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if indexPath.section == 1 {
            guard let move = movements[indexPath.row] else {
                let vc = MovementDetailView(movementIndex: indexPath.row, movement: nil)
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            let vc = MovementDetailView(movementIndex: indexPath.row, movement: move)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 && indexPath.section == 0 {
            // choose image
            print("Image")
        } else if indexPath.row == 3 && indexPath.section == 0 {
            let newIP = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            guard let cell = tableView.cellForRow(at: newIP) as? PickerTableViewCell else { return }
            cell.pickerView.isHidden = !cell.pickerView.isHidden
            cell.addButton.isHidden = !cell.addButton.isHidden
            cell.removeButton.isHidden = !cell.removeButton.isHidden
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            })
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CreateWorkoutViewController {
    
    @objc func handleSubmit() {
        self.view.endEditing(true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let actualMovements = movements.compactMap { $0 }
        
        if actualMovements.count == 0 {
            errorView?.callError(withTitle: "You don't have any complete movements. Add some", andColor: .red)
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        guard let wName = name else {
            errorView?.callError(withTitle: "Please add a name", andColor: .red)
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        guard let wDesc = desc else {
            errorView?.callError(withTitle: "Please add a description", andColor: .red)
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        
        guard let user = UserDefaultsStore.retrieve(User.self) else {
            errorView?.callError(withTitle: "Please sign in to create workouts", andColor: .red)
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        
        guard let userId = user.id, let userToken = user.token else {
            errorView?.callError(withTitle: "Please sign in to create workouts", andColor: .red)
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        
        if tags.count == 0 {
            errorView?.callError(withTitle: "Please add at least one tag", andColor: .red)
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        let work = Workout(name: wName, creator: userId, creatorName: nil, time: 0, description: wDesc, image: false, rating: 0, id: nil, tags: tags)
        
        
        let webWorkout = WebWorkout(workout: work, movements: actualMovements)
        
        WebWorkout.saveWorkout(webservice: webservice, token: userToken, workout: webWorkout, callback: { res in
            switch res {
            case .error(_):
                DispatchQueue.main.async {
                    self.errorView?.callError(withTitle: "Network Error", andColor: .red)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
                return
            case .success(let wor):
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    let webW = WebWorkout(workout: wor, movements: actualMovements)
                    self.finishWorkout(workout: webW)
                }
                return
            }
        })
    }
    
    func finishWorkout(workout: WebWorkout) {
        guard let _ = workout.id else {
            errorView?.callError(withTitle: "Something went wrong on our side", andColor: .red)
            return
        }
        let tags = workout.tags
        let alert = UIAlertController(title: "Add to day", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Just add to my workouts", comment: "Default action"), style: .cancel, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Sunday", comment: "Sunday"), style: .default, handler: { _ in
            self.addDayToRoutine(workout, forDay: 0, andTags: tags)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Monday", comment: "Monday"), style: .default, handler: { _ in
            self.addDayToRoutine(workout, forDay: 1, andTags: tags)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Tuesday", comment: "Tuesday"), style: .default, handler: { _ in
            self.addDayToRoutine(workout, forDay: 2, andTags: tags)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Wednesday", comment: "Wednesday"), style: .default, handler: { _ in
            self.addDayToRoutine(workout, forDay: 3, andTags: tags)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Thursday", comment: "Thursday"), style: .default, handler: { _ in
            self.addDayToRoutine(workout, forDay: 4, andTags: tags)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Friday", comment: "Friday"), style: .default, handler: { _ in
            self.addDayToRoutine(workout, forDay: 5, andTags: tags)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Saturday", comment: "Saturday"), style: .default, handler: { _ in
            self.addDayToRoutine(workout, forDay: 6, andTags: tags)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addDayToRoutine(_ workout: WebWorkout, forDay day: Int, andTags: [String]) {
        guard var routine = UserDefaultsStore.retrieve(Routine.self) else {
            errorView?.callError(withTitle: "You dont have a routine", andColor: .red)
            return
        }
        
        routine.finalizeDay(number: day, toWorkout: [workout], withTags: andTags)
        UserDefaultsStore.store(persistables: routine)
        
        guard let user = UserDefaultsStore.retrieve(User.self), let token = user.token else {
            errorView?.callError(withTitle: "Please login to an account", andColor: .red)
            return
        }
        
        User.saveUserRoutine(webservice: webservice, token: token, routine: routine, callback: { res in
            guard let result = res else {return}
            switch result {
            case .error(let error):
                DispatchQueue.main.async {
                    self.errorView?.callError(withTitle: error.localizedDescription, andColor: .red)
                }
            case .success(_):
                DispatchQueue.main.async {
                    self.errorView?.callError(withTitle: "Added to routine", andColor: .green)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        })
    }
}
