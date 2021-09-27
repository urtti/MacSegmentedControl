//
//  ViewController.swift
//  RCSegmentedControl
//
//  Created by Tommi Urtti on 25.9.2021.
//

import Cocoa


final class UserData: ObservableObject {
    @Published var selectedTab = 0
}

class ViewController:  NSViewController, SegmentControlDelegate {
    @Published private var contentIndex = 0
    private var contentView : NSTextField!
    private var segmentControl : SegmentControl!
    private var anotherSegmentControl : SegmentControl!
    private var sink : Any?

    func segmentWasSelected(_ sender: SegmentControl, index: Int?) {
        print("You could also be using the delegate pattern")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentControl = SegmentControl(labels: ["Map", "Public Transport", "Satellite"], frame: NSRect(x: 50, y: view.frame.height - SEGMENTCONTROL_HEIGHT - 20, width: view.frame.width - 100, height: SEGMENTCONTROL_HEIGHT), style: .proportional)
        segmentControl.delegate = self
        view.addSubview(segmentControl)

        anotherSegmentControl = SegmentControl(labels: ["On", "Off", "Yes", "No"], frame: NSRect(x: 50, y: view.frame.height - SEGMENTCONTROL_HEIGHT * 2 - 20 * 2, width: view.frame.width - 100, height: SEGMENTCONTROL_HEIGHT), style: .equal)
        view.addSubview(anotherSegmentControl)

        contentView = NSTextField(frame: NSRect(x: 20, y: 20, width: view.frame.width - 40, height: view.frame.height - segmentControl.frame.height * 2 - 100))
        contentView.isSelectable = false
        view.addSubview(contentView)

        segmentControl.onChange({ index, label in
            self.contentView.stringValue = "First control changed to index \(index) \(label)"
        })
        anotherSegmentControl.onChange({ index, label in
            self.contentView.stringValue = "Second control changed to index \(index) \(label)"
        })
    }


}
