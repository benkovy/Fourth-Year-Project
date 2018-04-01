//
//  MovementDetailView.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-21.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

protocol MovementDelegate {
    func didFinishEditingMovement(movement: Movement, forIndex index: Int)
}

class MovementDetailView: UIViewController, TableViewDelegatable, ErrorViewDelegate {
    
    var errorView: ErrorView?
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: MovementDelegate?
    var movement: Movement?
    var movementIndex: Int
    var nameCheck = false
    var name = ""
    var descCheck = false
    var descrip = ""
    var repsCheck = false
    var reps = 0
    var setsCheck = false
    var sets = 0
    var timeCheck = false
    var time = 0
    var checkAll: Bool {
        return nameCheck && descCheck && repsCheck && setsCheck && timeCheck
    }
    
    init(movementIndex: Int, movement: Movement?) {
        self.movementIndex = movementIndex
        self.movement = movement
        super.init(nibName: MovementDetailView.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateTableView()
        tableView.register(InputTableViewCell.self)
        tableView.register(PickerTableViewCell.self)
        if let m = self.movement {
            nameCheck = true; descCheck = true; repsCheck = true; setsCheck = true; timeCheck = true;
            name = m.name; descrip = m.description; reps = m.reps; sets = m.sets; time = m.restTime;
        }
        self.errorView = ErrorView(frame: CGRect(x: 0, y: -40, width: self.view.frame.width, height: 40))
        setupErrorView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let button = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(handleSubmit))
        navigationItem.setRightBarButton(button, animated: true)
    }
    
    func cellLabel(forIndexPath indexPath: IndexPath) -> String {
        switch (indexPath.section, indexPath.row) {
        case (0,0): return "Name"
        case (0,1): return "Description"
        case (1,0): return "Sets"
        case (1,1): return ""
        case (1,2): return "Reps"
        case (1,3): return ""
        case (1,4): return "Rest Time"
        default: return ""
        }
    }
    
    func numberOfLines(forIndexPath indexPath: IndexPath) -> Int {
        switch (indexPath.section, indexPath.row) {
        case (0,1): return 4
        default: return 1
        }
    }
    
    func pickerSelectedRow(sender: Int, row: Int, component: Int? = nil, indexPath: IndexPath) {
        let newIP = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        guard let cell = tableView.cellForRow(at: newIP) else { return }
        if sender == 6 {
            cell.detailTextLabel?.text = getTime(row: row)
            guard let text = cell.detailTextLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            timeCheck = text.isEmpty ? false : true
            if timeCheck {time = row}
            return
        } else {
            cell.detailTextLabel?.text = String(row)
            guard let text = cell.detailTextLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            if sender == 2 {
                setsCheck = text.isEmpty ? false : true
                if setsCheck {sets = row}
            }
            else if sender == 4 {
                repsCheck = text.isEmpty ? false : true
                if repsCheck {reps = row}
            }
            return
        }
    }
    
    func getTime(row: Int) -> String {
        if row < 60 {
            return "\(row) Seconds"
        }
        let seconds = row % 60
        let minutes = row / 60
        return "\(minutes)m \(seconds)s"
    }
    
    @objc func handleSubmit() {
        self.view.endEditing(true)
        // Check to see if all inputs are filled
        if checkAll {
            let movement = Movement(name: name, description: descrip, sets: sets, reps: reps, restTime: time, image: false)
            print(movement)
            if delegate != nil {
                delegate?.didFinishEditingMovement(movement: movement, forIndex: movementIndex)
                navigationController?.popViewController(animated: true)
            }
        } else {
            errorView?.callError(withTitle: "Please fill entire movement", andColor: .red)
        }
    }
}

extension MovementDetailView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0,0), (0,1):
            let cell: InputTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.textView.tag = indexPath.section + indexPath.row
            cell.textView.text = cellLabel(forIndexPath: indexPath)
            cell.didFinishEditing = { result in
                if result == "Name" { self.nameCheck = false; self.name = "" ;return }
                if result == "Description" { self.descCheck = false; self.descrip = ""; return }
                if !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if cell.textView.tag == 0 { self.nameCheck = true; self.name = result }
                    if cell.textView.tag == 1 { self.descCheck = true; self.descrip = result }
                } else {
                    if cell.textView.tag == 0 { self.nameCheck = false; self.name = ""}
                    if cell.textView.tag == 1 { self.descCheck = false; self.descrip = ""}
                }
            }
            cell.didRequestPlaceholder = { return self.cellLabel(forIndexPath: indexPath) }
            cell.textView.textContainer.maximumNumberOfLines = numberOfLines(forIndexPath: indexPath)
            cell.textView.textContainer.lineBreakMode = .byTruncatingTail
            if let m = self.movement {
                cell.textView.text = self.fillForMovement(movement: m, path: indexPath)
                cell.textView.textColor = .black
            }
            return cell
        case (1,1), (1,3):
            let cell: PickerTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.pickerView.tag = indexPath.row + indexPath.section
            cell.pickerView.selectRow(4, inComponent: 0, animated: true)
            cell.didRequestComponents = { return 1 }
            cell.didRequestRows = { return 50 }
            cell.didRequestTitles = { row in return String(row) }
            cell.didSelectRow = { row, tag, com in self.pickerSelectedRow(sender: tag, row: row, indexPath: indexPath) }
            return cell
        case (1,5):
            let cell: PickerTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.pickerView.tag = indexPath.section + indexPath.row
            cell.didRequestComponents = { return 1 }
            cell.didRequestRows = { return 241 }
            cell.didRequestTitles = { row in return String(row) }
            cell.didSelectRow = {row, tag, com in self.pickerSelectedRow(sender: tag, row: row, component: com, indexPath: indexPath)}
            return cell
        default:
            let cell = UITableViewCell(style: .value2, reuseIdentifier: nil)
            cell.textLabel?.text = cellLabel(forIndexPath: indexPath)
            if let m = self.movement { cell.detailTextLabel?.text = self.fillForMovement(movement: m, path: indexPath) }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 6
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,1): return 100
        case (1,1), (1,3), (1,5):
            guard let cell = tableView.cellForRow(at: indexPath) as? PickerTableViewCell else { return 0 }
            return cell.pickerView.isHidden ? 0 : 150
        default: return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        switch (indexPath.section, indexPath.row) {
        case (1,0), (1,2), (1,4):
            
            let newIP = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            guard let cell = tableView.cellForRow(at: newIP) as? PickerTableViewCell else { return }
            
            cell.pickerView.isHidden = !cell.pickerView.isHidden
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            })
        default: return
        }
    }
}


extension MovementDetailView {
    func fillForMovement(movement: Movement, path: IndexPath) -> String {
        switch (path.section, path.row) {
        case (0,0): return movement.name
        case (0,1): return movement.description
        case (1,0): return String(movement.sets)
        case (1,2): return String(movement.reps)
        case (1,4): return getTime(row: movement.restTime)
        default: return ""
        }
    }
}
