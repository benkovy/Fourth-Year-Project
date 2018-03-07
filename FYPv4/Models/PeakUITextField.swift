//
//  PeakUITextField.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-25.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

@IBDesignable
class PeakUITextField: UIView {
    
    var handleEndEditing: ((String?) -> ())?
    
    var textField: UITextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 270.0, height: 30.0))
    var line: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 270, height: 1.0))
    var labelView: UILabel = UILabel()
    
    @IBInspectable var label: String? {
        didSet { addLabelString() }
    }
    
    @IBInspectable var hasLine: Bool = true {
        didSet { addLine() }
    }
    
    @IBInspectable var hasTextField: Bool = true {
        didSet { addTextField() }
    }
    
    @IBInspectable var lineThickness: CGFloat = 1 {
        didSet { addLine() }
    }
    
    @IBInspectable var lineColor: UIColor = .gray {
        didSet { addLineColor() }
    }
    
    func addLabelString() {
        if let labelText = label {
            labelView = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height))
            labelView.textColor = .gray
            labelView.text = labelText
            self.labelView.font = self.labelView.font.withSize(16)
            self.addSubview(labelView)
        }
    }
    
    func addTextField() {
        textField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height))
        textField.textContentType = UITextContentType("")
        self.addSubview(textField)
        textField.delegate = self
    }
    
    func addLine() {
        if hasLine {
            line.removeFromSuperview()
            line = UIView(frame: CGRect(x: 0.0, y: self.bounds.height, width: self.bounds.width, height: lineThickness))
            addLineColor()
            self.addSubview(line)
        } else {
            line.removeFromSuperview()
        }
    }
    
    func addLineColor() {
        if hasLine {
            line.backgroundColor = lineColor
        }
    }
    
}

extension PeakUITextField: UITextFieldDelegate {
    
    func forceBackToNoText() {
        if self.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return
        }
        self.textField.text = ""
        self.labelView.center.y += 25.0
        self.labelView.textColor = .gray
        self.lineColor = .gray
        self.labelView.font = self.labelView.font.withSize(16)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            UIView.animate(withDuration: 0.3, animations: {
                self.labelView.center.y -= 25.0
                self.labelView.textColor = .peakBlue
                self.labelView.font = self.labelView.font.withSize(12)
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            UIView.animate(withDuration: 0.3, animations: {
                self.labelView.center.y += 25.0
                self.labelView.textColor = .gray
                self.lineColor = .gray
                self.labelView.font = self.labelView.font.withSize(16)
            })
        } else {
            self.handleEndEditing?(textField.text)
        }
    }
}

