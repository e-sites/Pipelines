//
//  PopupViewController.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 02/10/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation
import EasyPeasy
import AppKit

class PopupViewController: NSViewController {
    weak var popover: NSPopover?
    @IBOutlet private weak var stackView: NSStackView!
    @IBOutlet private weak var headerView: NSView!
    @IBOutlet private weak var footerView: NSView!
    
    private var _buildViews: [BuildView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        headerView.wantsLayer = true
        stackView.wantsLayer = true
        footerView.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
        stackView.layer?.backgroundColor = NSColor(calibratedWhite: 0.95, alpha: 1).cgColor

        _buildViews = (0..<Constants.totalBuilds).map { _ in
            let buildView = BuildView(frame: NSRect.zero)
            stackView.addArrangedSubview(buildView)
            buildView <- [
                Height(68),
                Width(*1.0).like(stackView).with(.medium)
            ]
            return buildView
        }
        _addBorders()
    }

    private func _addBorders() {
        let color = NSColor(calibratedWhite: 0.75, alpha: 1.0).cgColor
        var line = NSView()
        line.wantsLayer = true
        line.layer?.backgroundColor = color
        headerView.addSubview(line)
        line <- [
            Bottom(),
            Left(),
            Right(),
            Height(1)
        ]

        line = NSView()
        line.wantsLayer = true
        line.layer?.backgroundColor = color
        footerView.addSubview(line)
        line <- [
            Top(),
            Left(),
            Right(),
            Height(1)
        ]
    }

    var builds: [Build] = [] {
        didSet {
            _update()
        }
    }

    func show(from sender: NSView) {
        popover?.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.minY)
        _update()
        DispatchQueue.main.async {
            for buildView in self._buildViews {
                buildView.iconView.shouldAnimate = true
                buildView.updateText()
            }
        }
    }
}

extension PopupViewController {
    fileprivate func _update() {
        if stackView == nil {
            return
        }
        for (index, buildView) in _buildViews.enumerated() {
            if index >= builds.count {
                buildView.build = nil
            } else {
                buildView.build = builds[index]
            }
        }
    }
}

extension PopupViewController {
    @IBAction func tapMoreBuilds(_ sender: NSButton) {
        let url = URL(string: "https://buildkite.com/builds")!
        NSWorkspace.shared.open(url)
    }

    @IBAction func tapClose(_ sender: NSButton) {
        exit(0)
    }

    @IBAction func tapRefresh(_ sender: NSButton) {
        NotificationCenter.default.post(name: fetchBuildsNotification, object: nil)
    }

    func dismiss() {
        popover?.performClose(nil)
    }
}

