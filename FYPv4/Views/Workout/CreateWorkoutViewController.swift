//
//  CreateWorkoutViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-20.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class CreateWorkoutViewController: UIViewController, TableViewDelegatable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movementsLabel: UILabel!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var nameInput: UITextField!
    
    var movements: [Int] = []
    let maxMovements = 15
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Workout"
        self.delegateTableView()
        tableView.register(MovementTableViewCell.self)
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
        movements.append(num)
        num = num + 1
        tableView.reloadData()
    }
}

extension CreateWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return movements.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let reversedMovements: [Int] = movements.reversed()
        cell.movementName.text = "\(reversedMovements[indexPath.section])"
        cell.configureCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MovementTableViewCell else { return }
        UIView.animate(withDuration: 0.15, animations: {
            cell.mainCellView.alpha = 0.7
        }, completion: { _ in
            UIView.animate(withDuration: 0.15, animations: {
                cell.mainCellView.alpha = 1.0
                let vc = MovementDetailView()
                self.navigationController?.pushViewController(vc, animated: true)
            })
        })
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
