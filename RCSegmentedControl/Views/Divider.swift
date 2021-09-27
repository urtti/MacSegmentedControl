//
//  Divider.swift
//  RCSegmentedControl
//
//  Created by Tommi Urtti on 25.9.2021.
//

import Foundation
import Cocoa

class Divider: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.lightGray.withAlphaComponent(0.4).set()
        NSRect(origin: CGPoint(x: 0, y: 6), size: CGSize(width: 1, height: 16)).fill()
    }
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 1, height: SEGMENTCONTROL_HEIGHT)
    }
}
