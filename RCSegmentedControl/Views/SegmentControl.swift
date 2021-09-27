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

enum SegmentControlStyle {
    case equal
    case proportional

    var stackViewDistribution : NSStackView.Distribution {
        switch self {
        case .equal: return .fillEqually
        case .proportional : return .fillProportionally
        }
    }
}

class SegmentControl: NSView, SegmentDelegate {
    var delegate : SegmentControlDelegate?

    private var segments = [Segment]()
    private var dividers = [Divider]()
    private let segmentOverlay = SegmentOverlay(frame: .zero)
    private var stack : NSStackView!
    private var selectedSegment : Segment?
    private var style : SegmentControlStyle!

    private var changeCallbacks = [(Int, String) -> Void]()

    func onChange(_ newCallback : @escaping (Int, String) -> Void) {
        changeCallbacks.append(newCallback)
    }

    init(labels : [String], frame : NSRect, style : SegmentControlStyle) {
        super.init(frame: frame)
        self.segments = labels.compactMap({ Segment(label: $0)})
        self.selectedSegment = segments[0]
        self.style = style

        createViewsForStackView(style: style)
        addSubview(segmentOverlay)
        addSubview(stack)

        // Set initial state of overlay and dividers
        segmentOverlay.setFrameOrigin(CGPoint(x: SEGMENT_OVERLAY_PADDING, y: SEGMENT_OVERLAY_PADDING))
        segmentOverlay.setFrameSize(sizeForSegment(selectedSegment!))
        for (index, d) in dividers.enumerated() {
            d.animator().alphaValue = (0 == index) ? 0.0 : 1.0
        }
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

        // Callbacks to delegate pattern and callbacks
        delegate?.segmentWasSelected(self, index: newIndex)
        changeCallbacks.forEach({ $0(newIndex, selectedSegment?.attributedStringValue.string ?? "") })

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

    // More customization could be built through the top level UI component like this
    // preferably building some style palette that would dictate what can be configured
    // and it could be given at init or afterwards.
    func setUnselectedFont(font : NSFont) {
        segments.forEach({
            $0.unselectedFont = font
            $0.selectionChanged(didSelect : $0 == selectedSegment)
        })
    }

    func setSelectedFont(font : NSFont) {
        segments.forEach({
            $0.selectedFont = font
            $0.selectionChanged(didSelect : $0 == selectedSegment)
        })
    }

    private func sizeForSegment(_ segment : NSView) -> CGSize {
        switch style {
        case .equal:
            return CGSize(width: (frame.width - SEGMENT_OVERLAY_PADDING * 2) / CGFloat(segments.count), height: frame.height - SEGMENT_OVERLAY_PADDING * 2)
        case .proportional:
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
        case .none: return .zero
        }
    }

    private func createViewsForStackView(style : SegmentControlStyle) {
        stack = NSStackView(frame: NSRect(origin: .zero, size: CGSize(width: frame.width, height: SEGMENTCONTROL_HEIGHT)))

        for (index, s) in segments.enumerated() {
            s.segmentDelegate = self

            // Create dividers
            if style == .proportional && index > 0 {
                let divider = Divider()
                dividers.append(divider)
                stack.addView(divider, in: .leading)
            }

            stack.addView(s, in: .leading)
        }

        stack.spacing = 0
        stack.alignment = .centerY
        stack.wantsLayer = true
        stack.distribution = style.stackViewDistribution
    }

    override func updateLayer() {
        layer?.backgroundColor = NSColor(named: "SegmentBackgroundColor")!.cgColor
        layer?.cornerRadius = 8.91
    }
}
