//
//  LoginViewControllerTextViewExtension.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-26.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController {
    var firstNameBool: Bool? {
        return firstnameView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var lastNameBool: Bool? {
        return lastnameView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var dobBool: Bool? {
        return dateofbirthView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func canToggleNext() -> Bool {
        guard let dob = dobBool, let first = firstNameBool, let last = lastNameBool else { return false }
        return !dob && !last && !first
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dateofbirthView.textField.inputView = datePicker
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateofbirthView.textField.text = formatter.string(from: sender.date)
    }
    
    func toggleLetsGoButton() {
        switch state {
        case .create:
            if canSignUp {
                letsGoButton.isEnabled = true
            } else {
                letsGoButton.isEnabled = false
            }
        case .login:
            if canSignIn {
                letsGoButton.isEnabled = true
            } else {
                letsGoButton.isEnabled = false
            }
        }
    }
    
    func startListening() {
        emailView.handleEndEditing = { [weak self] string in
            guard let text = string?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            let email = Email(email: text)
            self?.webservice.load(BoolResponse.emailRequest(email)) { result in
                guard let result = result else { return }
                switch result {
                case .error(let error): print("Error: \(error)")
                case .success(let outcome):
                    DispatchQueue.main.async {
                        if outcome.outcome { // Email is not used
                            self?.emailView.lineColor = .green
                            self? .emailBool = true
                        } else { // Email is used
                            self?.emailView.lineColor = .red
                            self? .emailBool = false
                        }
                    }
                }
            }
            self?.toggleLetsGoButton()
        }
        
        passwordView.handleEndEditing = { [weak self] string in
            guard let pass = string?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let confirm = self?.confirmPasswordView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            if self?.state == .create {
                if pass.count < 5 {
                    self?.passwordView.lineColor = .red
                    self?.passBool = false
                } else {
                    self?.passwordView.lineColor = .green
                    self?.passBool = true
                }
                if !confirm.isEmpty {
                    if pass == confirm {
                        self?.confirmPasswordView.lineColor = .green
                    } else {
                        self?.confirmPasswordView.lineColor = .red
                    }
                }
            }
            self?.toggleLetsGoButton()
        }
        
        confirmPasswordView.handleEndEditing = { [weak self] string in
            guard let confirm = string?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let pass = self?.passwordView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            if self?.state == .create {
                if pass == confirm {
                    self?.confirmPasswordView.lineColor = .green
                    self?.passConfBool = true
                    self?.toggleLetsGoButton()
                    return
                }
                self?.confirmPasswordView.lineColor = .red
                self?.passConfBool = false
                self?.toggleLetsGoButton()
            }
        }
        
        lastnameView.handleEndEditing = { [weak self] string in
            if let bool = self?.canToggleNext() { self?.nextButton.isEnabled = bool }
        }
        
        firstnameView.handleEndEditing = { [weak self] string in
            if let bool = self?.canToggleNext() { self?.nextButton.isEnabled = bool }
        }
        
        dateofbirthView.handleEndEditing = { [weak self] string in
            if let bool = self?.canToggleNext() { self?.nextButton.isEnabled = bool }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 25
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height - 25
            }
        }
    }
    
    @objc func handleChange(_ sender: UITextField) {
        guard let confirm = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let pass = self.passwordView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if self.state == .create {
            if pass == confirm {
                self.confirmPasswordView.lineColor = .green
                self.passConfBool = true
                self.toggleLetsGoButton()
                return
            }
            self.confirmPasswordView.lineColor = .red
            self.passConfBool = false
            self.toggleLetsGoButton()
        }
    }
}
