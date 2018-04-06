//
//  PickerTableViewCell.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-25.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    var didRequestComponents: (() -> (Int))?
    var didRequestRows: (() -> (Int))?
    var didRequestTitles: ((Int) -> (String))?
    var didSelectRow: ((Int, Int, Int) -> ())?
    var didRemoveRow: ((Int) -> ())?
    var didAddRow: ((Int) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        addButton.isHidden = true
        removeButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func removeTag(_ sender: UIButton) {
        let index = pickerView.selectedRow(inComponent: 0)
        if pickerView.numberOfRows(inComponent: 0) != 0 {
            didRemoveRow?(index)
        }
    }
    
    @IBAction func addTag(_ sender: UIButton) {
        let index = pickerView.selectedRow(inComponent: 0)
        if pickerView.numberOfRows(inComponent: 0) != 0 {
            didAddRow?(index)
        }
    }
}

extension PickerTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return didRequestComponents?() ?? 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return didRequestRows?() ?? 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let str = didRequestTitles?(row) {
            return str
        } else {
            return "Please wait"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectRow?(row, pickerView.tag, component)
    }
}
