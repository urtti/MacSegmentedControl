//
//  SegmentOverlay.swift
//  RCSegmentedControl
//
//  Created by Tommi Urtti on 25.9.2021.
//

import Foundation
import Cocoa

class SegmentOverlay: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func updateLayer() {
        layer?.backgroundColor = NSColor(named: "SegmentColor")!.cgColor
        layer?.cornerRadius = 6.93
        layer?.shadowColor =  NSColor.black.cgColor
        layer?.shadowOpacity = NSAppearance.isDarkMode() ? 0 : 0.12
        layer?.shadowOffset = CGSize(width: 0, height: -4)
        layer?.shadowRadius = 4
        layer?.masksToBounds = false
    }
}

