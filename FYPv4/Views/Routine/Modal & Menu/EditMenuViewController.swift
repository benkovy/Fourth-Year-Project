//
//  EditMenuViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-15.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class EditMenuViewController: UIViewController, TableViewDelegatable {
    
    @IBOutlet weak var tapableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let menuItems = ["Clear", "Add Type"]
    let day: Int
    weak var delegate: EditMenuDelegatable?
    
    init(delegate: EditMenuDelegatable, forDay: Int) {
        self.day = forDay
        self.delegate = delegate
        super.init(nibName: EditMenuViewController.nibName, bundle: nil)
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        self.tapableView.addGestureRecognizer(gesture)
        self.delegateTableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension EditMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            clear()
        } else if indexPath.row == 1 {
            add()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Edit"
    }
    
    func clear() {
        delegate?.menuDidRequestClear(forDay: day)
        self.dismiss(animated: true, completion: nil)
    }
    
    func add() {
        self.dismiss(animated: true, completion: nil)
        delegate?.menuDidRequestAdd(value: ["":""], forDay: day)
        
    }
    
    @objc func closeMenu() {
        self.dismiss(animated: true, completion: nil)
    }
}
