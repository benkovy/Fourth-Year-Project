//
//  InputTableViewCell.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-23.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var didFinishEditing: ((String) -> ())?
    var didRequestPlaceholder: (() -> (String))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        textView.textColor = UIColor.lightGray.withAlphaComponent(0.2)
        textView.contentInset =  UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textView.text = didRequestPlaceholder?()
            textView.textColor = UIColor.lightGray.withAlphaComponent(0.2)
        }
        didFinishEditing?(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray.withAlphaComponent(0.2) {
            textView.textColor = .black
            textView.text = nil
        }
    }
}
