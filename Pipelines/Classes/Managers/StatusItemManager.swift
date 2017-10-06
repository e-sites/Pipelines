//
//  StatusItem.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 28/09/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation
import Cocoa
import EasyPeasy
import Apollo

typealias Build = LatestBuildsQuery.Data.Viewer.User.Build.Edge.Node

class StatusItemManager {
    private(set) var statusItem: NSStatusItem!
    private var _statusIcons: [StatusIconView] = []
    private let popover = NSPopover()
    private var popupViewController: PopupViewController!
    private var _popoverTransiencyMonitor: Any?
    lazy private var _container: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.spacing = 3
        return stackView
    }()

    init() {
        let nibName = NSNib.Name("PopupViewController")
        popover.appearance = NSAppearance(named: .aqua)
        popover.animates = false
        popover.behavior = .transient
        let controller = PopupViewController(nibName: nibName, bundle: Bundle.main)
        popupViewController = controller
        popover.contentViewController = controller
        controller.popover = popover
    }

    private func _addNewStatusIconView() {

        let iconView = StatusIconView(frame: NSRect.zero)
        _statusIcons.append(iconView)
        _container.addArrangedSubview(iconView)
        iconView <- [
            Size(17)
        ]
        statusItem.length = CGFloat(_statusIcons.count * 20) - _container.spacing
    }

    func setup(with statusItem: NSStatusItem) {
        if self.statusItem != nil {
            fatalError("Already set up!")
        }
        self.statusItem = statusItem
        guard let button = statusItem.button else {
            return
        }

        button.target = self
        button.action = #selector(_tapStatusButton)

        button.addSubview(_container)
        _container <- Edges()
        statusItem.length = NSStatusItem.squareLength
    }

    var nodes: [Build] = [] {
        didSet {
            _updateNodes()
        }
    }

    private func _updateNodes() {
        for (index, node) in nodes.enumerated() {
            if index == _statusIcons.count {
                _addNewStatusIconView()
            }
            let iconView = _statusIcons[index]
            iconView.state = BuildState(from: node.state)
            if !NotificationManager.default.hasNotificationBeenTriggered(for: node) {
                NotificationManager.default.triggerLocalNotification(for: node)
            }
        }
        popupViewController.builds = nodes
    }

    @objc
    private func _tapStatusButton() {
        guard let button = statusItem.button else {
            return
        }
        if !popover.isShown {
            if _popoverTransiencyMonitor == nil {
                _popoverTransiencyMonitor = NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask([ .leftMouseDown, .rightMouseDown, .keyUp])) { [weak self] _ in
                    guard let `self` = self, let monitor = self._popoverTransiencyMonitor else {
                        return
                    }
                    NSEvent.removeMonitor(monitor)
                    self._popoverTransiencyMonitor = nil
                    self.popover.close()
                }
            }
            NSApplication.shared.activate(ignoringOtherApps: true)
            popupViewController.show(from: button)
        } else {
            popover.close()

        }
    }
}
