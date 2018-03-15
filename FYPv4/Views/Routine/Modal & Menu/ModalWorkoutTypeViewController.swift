//
//  ModalWorkoutTypeViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-12.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class ModalWorkoutTypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    let pickerItems = WorkoutType.allTypes
    var delegate: ModalDelegatable
    var day: String
    let indexPath: IndexPath
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeModal))
        self.view.addGestureRecognizer(gesture)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.modalView.clipsToBounds = true
        self.modalView.roundCorners(by: 20)
        self.doneButton.styleButtonFYP(withTitle: "Done")
        self.modalPresentationStyle = .overCurrentContext
    }
    
    init(delegate: ModalDelegatable, day: String, indexPath: IndexPath) {
        self.delegate = delegate
        self.day = day
        self.indexPath = indexPath
        super.init(nibName: ModalWorkoutTypeViewController.nibName, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func doneButtonPress(_ sender: UIButton) {
        let value = pickerItems[picker.selectedRow(inComponent: 0)]
        delegate.modalPassingBack(value: value, forCellAt: self.indexPath)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeModal() {
        delegate.modalDidCancel(forCellAt: indexPath)
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: pickerItems[row])
    }
}
