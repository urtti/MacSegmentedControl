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
    private var labelText : String = ""

    convenience init(label : String, segmentDelegate : SegmentDelegate? = nil) {
        let paragraphStyle = NSMutableParagraphStyle(alignment : .center)
        let attributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.kern: -0.25, NSAttributedString.Key.paragraphStyle : paragraphStyle]
        self.init(labelWithAttributedString: NSAttributedString(string: label, attributes: attributes))
        labelText = label
        backgroundColor = .clear
        font = NSFont.systemFont(ofSize: 13, weight: .semibold)
        self.segmentDelegate = segmentDelegate
    }

    override func mouseDown(with event: NSEvent) {
        print("\(self.stringValue)")
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
        font = NSFont.systemFont(ofSize: 13, weight: .medium)
    }

    private func setSelectedFont() {
        font = NSFont.systemFont(ofSize: 13, weight: .semibold)
    }
}
