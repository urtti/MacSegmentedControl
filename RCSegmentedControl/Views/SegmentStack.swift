//
//  SegmentStack.swift
//  RCSegmentedControl
//
//  Created by Tommi Urtti on 25.9.2021.
//

import Foundation
import Cocoa

class SegmentStack : NSStackView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setProperties()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setProperties()
    }

    private func setProperties() {
        spacing = 0
        alignment = .centerY
        wantsLayer = true
        distribution = .fillProportionally
    }
}
