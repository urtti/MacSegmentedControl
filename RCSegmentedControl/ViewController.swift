//
//  ViewController.swift
//  RCSegmentedControl
//
//  Created by Tommi Urtti on 25.9.2021.
//

import Cocoa

class ViewController:  NSViewController, SegmentControlDelegate {
    var contentView : NSTextField!
    var segmentControl : SegmentControl!

    func segmentWasSelected(_ sender: SegmentControl, index: Int?) {
        print("Selected segment: \(String(describing: index))")
        contentView.stringValue = "Selected segment: \(String(describing: index))"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentControl = SegmentControl(labels: ["Map", "Public Transport", "Satellite"], frame: NSRect(x: 50, y: view.frame.height - SEGMENTCONTROL_HEIGHT - 20, width: view.frame.width - 100, height: SEGMENTCONTROL_HEIGHT))
        segmentControl.delegate = self
        view.addSubview(segmentControl)

        contentView = NSTextField(frame: NSRect(x: 20, y: 20, width: view.frame.width - 40, height: view.frame.height - segmentControl.frame.height - 50))
        contentView.isSelectable = false
        view.addSubview(contentView)

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }
}
