//
//  BuildView.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 03/10/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation
import AppKit
import EasyPeasy
import Apollo

class BuildView: NSControl {

    let iconView = StatusIconView(frame: NSRect.zero)
    let titleLabel = NSTextField()
    private var _mouseDown = false
    private var _mouseOver = false

    private lazy var _dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "UTC")
        df.dateFormat = "YYYY-MM-dd'T'HH:mm:ss'Z'"
        return df
    }()

    var build: Build? {
        didSet {

            if oldValue?.id == build?.id && oldValue?.state == build?.state {
                updateText()
                return
            }
            _update()
        }
    }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        iconView.shouldAnimate = false
        self.addSubview(iconView)
        iconView <- [
            CenterY(),
            Left(10),
            Size(28)
        ]
        self.wantsLayer = true

        self.addSubview(titleLabel)
        titleLabel <- [
            CenterY(),
            Left(53),
            Height(>=0),
            Width(<=1.0*0.8).like(self),
            Right(10)
        ]
        titleLabel.isBordered = false
        titleLabel.isBezeled = false
        titleLabel.isEditable = false
        titleLabel.isSelectable = false
        titleLabel.drawsBackground = false
        titleLabel.maximumNumberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.isEnabled = true
        titleLabel.font = NSFont.systemFont(ofSize: 12)
        titleLabel.textColor = NSColor.gray
        self.layer?.backgroundColor = NSColor.white.cgColor

    }

    override var frame: NSRect {
        didSet {
            while !self.trackingAreas.isEmpty {
                self.removeTrackingArea(self.trackingAreas.first!)
            }
            let area = NSTrackingArea(rect: bounds,
                                      options: [.mouseEnteredAndExited, .activeAlways],
                                      owner: self,
                                      userInfo: nil)
            self.addTrackingArea(area)
        }
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    private func _update() {
        guard let build = build else {
            iconView.state = .empty
            titleLabel.stringValue = ""
            return
        }
        self.layout()

        iconView.state = BuildState(from: build.state)
        updateText()
    }

    func updateText() {
        guard let build = build, let pipeline = build.pipeline else {
            iconView.state = .empty
            titleLabel.stringValue = ""
            return
        }

        let buildMessage = build.message.emojiRendered
        let pipelineName = pipeline.name.emojiRendered
        var dateString = ""
        if let createdAt = build.createdAt, let date = _dateFormatter.date(from: createdAt) {
            dateString = date.timeAgoReadable().lowercased()
        }
        let string = "\(buildMessage) in \(pipelineName)\n\(iconView.state.title) \(dateString)"
        let attrstr = NSMutableAttributedString(string: string)

        attrstr.addAttributes([
            .font: NSFont.boldSystemFont(ofSize: 12),
            .foregroundColor: NSColor.black
            ], range: (string as NSString).range(of: buildMessage))
        titleLabel.attributedStringValue = attrstr
        titleLabel.sizeToFit()
    }
}

extension BuildView {
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        _mouseDown = true
        self.layer?.backgroundColor = NSColor.blue.withAlphaComponent(0.06).cgColor
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        _mouseOver = true
        self.layer?.backgroundColor = NSColor(calibratedWhite: 0.97, alpha: 1).cgColor
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        _mouseOver = false
        if _mouseDown {
            return
        }
        self.layer?.backgroundColor = NSColor.white.cgColor
    }

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        _mouseDown = false
        if _mouseOver {
            if let build = build, let url = URL(string: build.url) {
                NSWorkspace.shared.open(url)
            }

            self.layer?.backgroundColor = NSColor(calibratedWhite: 0.98, alpha: 1).cgColor
        } else {
            self.layer?.backgroundColor = NSColor.white.cgColor
        }
    }

}
