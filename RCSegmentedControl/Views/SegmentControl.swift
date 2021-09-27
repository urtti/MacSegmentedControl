//
//  SegmentControl.swift
//  RCSegmentedControl
//
//  Created by Tommi Urtti on 25.9.2021.
//

import Foundation
import Cocoa

let SEGMENTCONTROL_HEIGHT = CGFloat(28)
let SEGMENT_OVERLAY_PADDING = CGFloat(2)

protocol SegmentControlDelegate {
    func segmentWasSelected(_ sender : SegmentControl, index : Int?)
}
protocol SegmentDelegate {
    func segmentWasSelected(_ sender : Segment)
}

class SegmentControl: NSView, SegmentDelegate {
    private var segments = [Segment]()
    private var dividers = [Divider]()
    private let segmentOverlay = SegmentOverlay(frame: .zero)
    private let stack : SegmentStack!
    private var selectedSegment : Segment?
    var delegate : SegmentControlDelegate?

    init(labels : [String], frame : NSRect) {
        segments = labels.compactMap({ Segment(label: $0)})
        selectedSegment = segments[0]
        stack = SegmentStack(frame: NSRect(origin: .zero, size: CGSize(width: frame.width, height: SEGMENTCONTROL_HEIGHT)))

        super.init(frame: frame)
        createViewsForStackView()
        addSubview(segmentOverlay)
        addSubview(stack)

        // Set initial state of overlay and dividers
        segmentOverlay.setFrameOrigin(CGPoint(x: SEGMENT_OVERLAY_PADDING, y: SEGMENT_OVERLAY_PADDING))
        segmentOverlay.setFrameSize(sizeForSegment(selectedSegment!))
        for (index, d) in dividers.enumerated() {
            d.animator().alphaValue = (0 == index) ? 0.0 : 1.0
        }

        setProperties()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func segmentWasSelected(_ sender: Segment) {
        // Set the new segment
        guard let newIndex = segments.firstIndex(of: sender) else {
            assertionFailure("Segment not in control")
            return
        }

        selectedSegment = sender
        delegate?.segmentWasSelected(self, index: newIndex)

        // Set styles for segments based on selection
        segments.forEach({ $0.selectionChanged(didSelect : $0 == selectedSegment) })

        // Animate new segment selection
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.2
            let isLast = newIndex == segments.count - 1
            let isFirst = newIndex == 0
            let size = sizeForSegment(selectedSegment!)
            let x = isFirst ? SEGMENT_OVERLAY_PADDING : isLast ? frame.width - SEGMENT_OVERLAY_PADDING - size.width : sender.frame.minX
            let newFrame = NSRect(origin: CGPoint(x: x, y: SEGMENT_OVERLAY_PADDING), size: size)
            segmentOverlay.animator().frame = newFrame
        })

        // Animate fades of dividers
        for (index, d) in dividers.enumerated() {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.4
                d.animator().alphaValue = (newIndex == index || newIndex - 1 == index) ? 0.0 : 1.0
            }
        }
    }

    private func sizeForSegment(_ segment : NSView) -> CGSize {
        // Segments
        let segmentsWidth = segments
            .compactMap({$0.intrinsicContentSize.width})
            .reduce(CGFloat.zero, { x, y in
                x + y
            })

        // Dividers
        let dividersWidth = dividers
            .compactMap({$0.intrinsicContentSize.width})
            .reduce(CGFloat.zero, { x, y in
                x + y
            })

        let proportion = selectedSegment!.intrinsicContentSize.width / (segmentsWidth + dividersWidth)
        return CGSize(width: (frame.width - SEGMENT_OVERLAY_PADDING * 2) * proportion, height: frame.height - SEGMENT_OVERLAY_PADDING * 2)
    }

    private func createViewsForStackView() {
        for (index, s) in segments.enumerated() {
            s.segmentDelegate = self

            // Create dividers
            if index > 0 {
                let divider = Divider()
                dividers.append(divider)
                stack.addView(divider, in: .leading)
            }

            stack.addView(s, in: .leading)
        }
    }

    private func setProperties() {
        wantsLayer = true
        layer?.backgroundColor = NSColor(named: "SegmentBackgroundColor")!.cgColor
        layer?.cornerRadius = 8.91
    }
}
