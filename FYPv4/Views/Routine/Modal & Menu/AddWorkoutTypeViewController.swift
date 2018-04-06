//
//  AddWorkoutTypeViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-04-05.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class AddWorkoutTypeViewController: UIViewController, TableViewDelegatable, ErrorViewDelegate {
    var errorView: ErrorView?
    

    @IBOutlet weak var tapableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let menuItems = ["Type Name", "Add"]
    let webservice = WebService()
    var typeName: String?
    
    init() {
        super.init(nibName: AddWorkoutTypeViewController.nibName, bundle: nil)
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(InputTableViewCell.self)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        self.tapableView.addGestureRecognizer(gesture)
        self.delegateTableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        errorView = ErrorView(frame: CGRect(x: 0, y: -40, width: self.view.frame.width, height: 40))
        errorView?.backgroundColor = .clear
        setupErrorView()
    }
}

extension AddWorkoutTypeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func handleAddType(type: String) {
        if !type.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // not empty
            if type == "Type Name" {
                errorView?.callError(withTitle: "Please Enter A Type", andColor: .red)
                return
            } else if type.count > 12{
                errorView?.callError(withTitle: "Type Name Too Long", andColor: .red)
                return
            } else {
                webservice.load(WebWorkout.workoutTag(tags: [type]), completion: { res in
                    guard let result = res else {return}
                    switch result {
                    case .error(_):
                        self.errorView?.callError(withTitle: "Type Could Not Be Added", andColor: .red)
                    case .success(_):
                        self.errorView?.callError(withTitle: "Type Added", andColor: .peakBlue, doneDisplaying: {
                            self.errorView?.backgroundColor = .clear
                            self.errorView?.errorLabel.text = ""
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: InputTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.textView.text = "Type Name"
            cell.didRequestPlaceholder = { return self.menuItems[indexPath.row] }
            cell.didFinishEditing = { result in self.typeName = result }
            cell.textView.textContainer.maximumNumberOfLines = 1
            cell.textView.textContainer.lineBreakMode = .byTruncatingTail
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = menuItems[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        guard let str = typeName else { return }
        handleAddType(type: str)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Add Type"
    }
    
    @objc func closeMenu() {
        self.dismiss(animated: true, completion: nil)
    }
}
