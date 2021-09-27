//
//  Segment.swift
//  RCSegmentedControl
//
//  Created by Tommi Urtti on 25.9.2021.
//

import Foundation
import Cocoa

class Segment: NSTextField {
    var segmentDelegate : SegmentDelegate?
    var unselectedFont = NSFont.systemFont(ofSize: 13, weight: .medium)
    var selectedFont = NSFont.systemFont(ofSize: 13, weight: .semibold)

    convenience init(label : String, selected : Bool, delegate segmentDelegate : SegmentDelegate? = nil) {
        self.init(labelWithAttributedString: NSAttributedString(string: label, attributes: [ NSAttributedString.Key.kern: -0.25, NSAttributedString.Key.paragraphStyle : NSMutableParagraphStyle(alignment : .center)]))
        backgroundColor = .clear
        selectionChanged(didSelect: selected)
        self.segmentDelegate = segmentDelegate
    }

    override func mouseDown(with event: NSEvent) {
        segmentDelegate?.segmentWasSelected(self)
    }

    func selectionChanged(didSelect : Bool) {
        if didSelect {
            setSelectedFont()
        } else {
            setUnselectedFont()
        }
    }

    private func setUnselectedFont() {
        font = unselectedFont
    }

    private func setSelectedFont() {
        font = selectedFont
    }
}
