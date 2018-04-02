//
//  WorkoutDetailView.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-04-01.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class WorkoutDetailView: UIViewController, TableViewDelegatable, ErrorViewDelegate {
    var errorView: ErrorView?
    
    var userDidSelect: (() -> ())?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var controlButton: UISegmentedControl!
    
    let webservice = WebService()
    let workout: WebWorkout
    let day: Int
    let segmentBool: Bool
    var collapsed: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.delegateTableView()
        tableView.register(WorkoutDetailViewTableViewCell.self)
        tableView.register(MovementDetailViewTableViewCell.self)
        style()
        setupSgementControl()
        errorView = ErrorView(frame: CGRect(x: 0, y: -40, width: self.view.frame.width, height: 40))
        errorView?.backgroundColor = .clear
        errorView?.errorLabel.text = ""
        setupErrorView()
    }
    
    init(workout: WebWorkout, canAdd: Bool, day: Int) {
        self.workout = workout
        self.day = day
        self.segmentBool = canAdd
        if let movements = workout.movements {
            for _ in movements {
                collapsed.append(true)
            }
        }
        super.init(nibName: WorkoutDetailView.nibName, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style() {
        tableView.roundCorners(by: 12)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.peakBlue.cgColor
    }
    
    func setupSgementControl() {
        controlButton.isMomentary = true
        controlButton.removeAllSegments()
        let font = UIFont.systemFont(ofSize: 20)
        controlButton.setTitleTextAttributes([NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.peakBlue], for: .normal)
        if segmentBool {
            controlButton.insertSegment(withTitle: "Close", at: 0, animated: true)
            controlButton.insertSegment(withTitle: "Select", at: 1, animated: true)
        } else {
            controlButton.insertSegment(withTitle: "Close", at: 0, animated: true)
        }
        controlButton.backgroundColor = .white
        controlButton.roundCorners(by: 10)
        controlButton.layer.borderColor = UIColor.peakBlue.cgColor
        controlButton.layer.borderWidth = 1
        controlButton.layer.masksToBounds = true
    }
    
    func retrieveCollapsed(row: Int) -> Bool {
        return collapsed[row]
    }
    
    @IBAction func controlDidTap(_ sender: UISegmentedControl) {
        if !segmentBool {
            dismiss(animated: true, completion: nil)
        } else {
            if sender.selectedSegmentIndex == 0 {
                dismiss(animated: true, completion: nil)
            } else if sender.selectedSegmentIndex == 1 {
                self.handleSelect()
            }
        }
    }
    
    func handleSelect() {
        guard let _ = workout.id else {
            return
        }
        let tags = workout.tags
        self.addDayToRoutine(self.workout, forDay: day, andTags: tags)
    }
    
    func addDayToRoutine(_ workout: WebWorkout, forDay day: Int, andTags: [String]) {
        guard var routine = UserDefaultsStore.retrieve(Routine.self) else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let dayG = Date.givenDay(section: day) else { return }
        routine.finalizeDay(number: dayG, toWorkout: [workout], withTags: andTags)
        
        UserDefaultsStore.store(persistables: routine)
        
        guard let user = UserDefaultsStore.retrieve(User.self), let token = user.token else {
            errorView?.callError(withTitle: "Please login to an account", andColor: .red)
            self.dismiss(animated: true, completion: nil)
            return
        }
        let sv = WorkoutDetailView.displaySpinner(onView: self.view)
        User.saveUserRoutine(webservice: webservice, token: token, routine: routine, callback: { res in
            DispatchQueue.main.async {
                WorkoutDetailView.removeSpinner(spinner: sv)
            }
            guard let result = res else {return}
            switch result {
            case .error(let error):
                DispatchQueue.main.async {
                    self.errorView?.callError(withTitle: error.localizedDescription, andColor: .red)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            case .success(_):
                DispatchQueue.main.async {
                    self.userDidSelect?()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        })
    }
    
}

extension WorkoutDetailView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0)
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0)
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let cell: WorkoutDetailViewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: workout)
            cell.selectionStyle = .none
            return cell
        case (1,_):
            let cell: MovementDetailViewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            guard let movement = workout.movements?[indexPath.row] else {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                return cell
            }
            cell.selectionStyle = .none
            cell.configure(with: movement)
            return cell
        default:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return workout.movements?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.collapsed[indexPath.row] = !self.collapsed[indexPath.row]
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            return 300
        case (1,_):
            return self.retrieveCollapsed(row: indexPath.row) ? 72 : 160
        default:
            return 0
        }
    }
}
