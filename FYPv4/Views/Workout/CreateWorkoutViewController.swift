//
//  CreateWorkoutViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-20.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class CreateWorkoutViewController: UIViewController, TableViewDelegatable, MovementDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movements: [Movement?] = []
    let maxMovements = 15
    var num = 0
    var name: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Workout"
        self.delegateTableView()
        tableView.register(InputTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let button = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(handleSubmit))
        navigationItem.setRightBarButton(button, animated: true)
    }
    
    @objc func addMovement(_ sender: UIButton) {
        movements.insert(nil, at: 0)
        tableView.reloadData()
    }
    
    func didFinishEditingMovement(movement: Movement, forIndex index: Int) {
        movements.remove(at: index)
        movements.insert(movement, at: index)
        tableView.reloadData()
    }
    
    func cellLabel(forIndexPath indexPath: IndexPath) -> String {
        switch (indexPath.section, indexPath.row) {
        case (0,0): return "Name"
        case (0,1): return "Description"
        case (0,2): return "Image"
        default: return ""
        }
    }
}

extension CreateWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
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
                cell.textView.text = cellLabel(forIndexPath: indexPath)
                cell.didRequestPlaceholder = { return self.cellLabel(forIndexPath: indexPath) }
                cell.didFinishEditing = { text in
                    if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        if text == "Name" { self.name = nil; return }
                        if text == "Description" { self.desc = nil; return }
                        if indexPath.row == 1 { self.desc = text }
                        if indexPath.row == 0 { self.name = text }
                    }
                }
                return cell
            } else {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.textLabel?.text = cellLabel(forIndexPath: indexPath)
                cell.detailTextLabel?.text = "Choose"
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,1): return 116
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
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CreateWorkoutViewController {
    
    @objc func handleSubmit() {
        self.view.endEditing(true)
        let actualMovements = movements.compactMap { $0 }
        if actualMovements.count == 0 { print("EMPTY") } // show error message "No movements"
        if name != nil { print(name)}
        if desc != nil { print(desc)}
        
    }
}
