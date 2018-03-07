//
//  PeakUITextFieldDelegate.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-25.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

protocol PeakUITextFieldDelegate: class {
    func handleLiveCheck(_ string: String)
}

extension PeakUITextFieldDelegate {
    func handleLiveCheck() {}
}
