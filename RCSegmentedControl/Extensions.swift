//
//  Extensions.swift
//  RCSegmentedControl
//
//  Created by Tommi Urtti on 27.9.2021.
//

import Foundation
import Cocoa

extension NSMutableParagraphStyle {
    convenience init(alignment : NSTextAlignment) {
        self.init()
        self.alignment = alignment
    }
}
