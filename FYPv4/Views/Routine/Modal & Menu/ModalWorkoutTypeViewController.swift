//
//  ModalWorkoutTypeViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-12.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class ModalWorkoutTypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var currentTags: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var chooseButton: UISegmentedControl!
    
    var pickerWillReturnWithValues: (([String]) -> ())?
    
    let webservice = WebService()
    var pickerItems: [String]?
    weak var delegate: ModalDelegatable?
    var day: String
    let indexPath: IndexPath
    var tags: [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTags.setFontTo(style: .paragraph)
        currentTags.text = tags.joined(separator: "|").capitalized
        modalView.layer.borderColor = UIColor.peakBlue.cgColor
        modalView.layer.borderWidth = 1
        self.picker.delegate = self
        self.picker.dataSource = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeModal))
        self.view.addGestureRecognizer(gesture)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.modalView.clipsToBounds = true
        self.modalView.roundCorners(by: 20)
        self.modalPresentationStyle = .overCurrentContext
        setupSgementControl()
    }
    
    init(delegate: ModalDelegatable, day: String, indexPath: IndexPath, currentTags: [String]?) {
        self.delegate = delegate
        self.day = day
        self.indexPath = indexPath
        self.tags = currentTags ?? []
        super.init(nibName: ModalWorkoutTypeViewController.nibName, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getWorkoutTypes()
    }
    
    func setupSgementControl() {
        chooseButton.isMomentary = true
        chooseButton.removeAllSegments()
        let font = UIFont.systemFont(ofSize: 16)
        chooseButton.setTitleTextAttributes([NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.peakBlue], for: .normal)
        chooseButton.insertSegment(withTitle: "Add", at: 0, animated: true)
        chooseButton.insertSegment(withTitle: "Done", at: 1, animated: true)
        chooseButton.insertSegment(withTitle: "Remove", at: 2, animated: true)
        chooseButton.backgroundColor = .white
        chooseButton.roundCorners(by: 10)
        chooseButton.layer.borderColor = UIColor.peakBlue.cgColor
        chooseButton.layer.borderWidth = 1
        chooseButton.layer.masksToBounds = true
    }
    
    func getWorkoutTypes() {
        let sv = UIView.displaySpinner(onView: modalView)
        webservice.load(WebWorkout.workoutTag(tags: []), completion: { res in
            UIView.removeSpinner(spinner: sv)
            guard let result = res else { return }
            switch result {
            case .error(_):
                print("There was an error in retrieving the tags")
            case .success(let tags):
                self.pickerItems = tags.compactMap { $0.name }
                self.picker.reloadAllComponents()
            }
        })
    }
    
    @IBAction func chooseButtonPress(_ sender: UISegmentedControl) {
        let seg = sender.selectedSegmentIndex
        guard let str = self.pickerItems?[picker.selectedRow(inComponent: 0)] else { return }
        let value = String(describing: str)
        switch seg {
        case 0:
            if !tags.contains(value) {
                tags.append(value)
            }
            currentTags.text = tags.joined(separator: " | ").capitalized
        case 1:
            pickerWillReturnWithValues?(tags)
            self.dismiss(animated: true, completion: nil)
        case 2:
            if let index = tags.index(of: value) {
                tags.remove(at: index)
            }
            currentTags.text = tags.joined(separator: " | ").capitalized
        default:
            print("How?")
        }
        
    }
    
    @objc func closeModal() {
        delegate?.modalDidCancel(forCellAt: indexPath)
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let str = self.pickerItems?[row] else { return "Please Wait"}
        return String(describing: str).capitalized
    }
    
}
