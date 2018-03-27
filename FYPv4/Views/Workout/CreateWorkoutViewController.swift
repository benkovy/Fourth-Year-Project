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
    @IBOutlet weak var movementsLabel: UILabel!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var nameInput: UITextField!
    
    var movements: [Movement?] = []
    let maxMovements = 15
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Workout"
        self.delegateTableView()
        self.configureViews()
        descriptionInput.delegate = self
        descriptionInput.text = "Tell us about this workout..."
        descriptionInput.textColor = UIColor.lightGray.withAlphaComponent(0.2)
        descriptionInput.layer.borderColor = UIColor.lightGray.cgColor
        descriptionInput.layer.borderWidth = 1
        descriptionInput.roundCorners(by: 5)
        nameInput.layer.borderColor = UIColor.lightGray.cgColor
        nameInput.layer.borderWidth = 1
        nameInput.roundCorners(by: 5)
    }
    
    @IBAction func addMovement(_ sender: UIButton) {
        movements.insert(nil, at: 0)
        tableView.reloadData()
    }
    
    func didFinishEditingMovement(movement: Movement, forIndex index: Int) {
        movements.remove(at: index)
        movements.insert(movement, at: index)
        tableView.reloadData()
    }
}

extension CreateWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        guard let move = movements[indexPath.row] else {
            cell.textLabel?.text = "New Movement"
            return cell
        }
        cell.textLabel?.text = move.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovementDetailView(movementIndex: indexPath.row)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CreateWorkoutViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray.withAlphaComponent(0.2) {
            textView.textColor = .black
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textView.text = "Tell us about this workout..."
            textView.textColor = UIColor.lightGray.withAlphaComponent(0.2)
        }
    }
}

extension CreateWorkoutViewController {
    func configureViews() {
        movementsLabel.setFontTo(style: .inputLabel)
        movementsLabel.text = "Movements"
        
    }
}
