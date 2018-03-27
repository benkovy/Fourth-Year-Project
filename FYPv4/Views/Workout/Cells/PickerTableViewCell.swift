//
//  PickerTableViewCell.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-25.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pickerView: UIPickerView!
    var didRequestComponents: (() -> (Int))?
    var didRequestRows: (() -> (Int))?
    var didRequestTitles: ((Int) -> (String))?
    var didSelectRow: ((Int, Int, Int) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        return didRequestTitles?(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectRow?(row, pickerView.tag, component)
    }
}
