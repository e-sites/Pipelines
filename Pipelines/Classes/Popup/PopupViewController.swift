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
    lazy private var _buildViews: [BuildView] = {
        var ar: [BuildView] = []
        for _ in 0..<5 {
            let buildView = BuildView(frame: NSRect.zero)
            stackView.addArrangedSubview(buildView)
            buildView <- [
                Height(68),
                Width(*1.0).like(stackView).with(.medium)
            ]
            ar.append(buildView)
        }
        return ar
    }()
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        headerView.wantsLayer = true
        stackView.wantsLayer = true
        footerView.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
        stackView.layer?.backgroundColor = NSColor.white.cgColor
    }

    var builds: [Build] = [] {
        didSet {
            _update()
        }
    }

    func show(from sender: NSView) {
        popover?.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.minY)
        _update()
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
        close()
    }

    @IBAction func tapClose(_ sender: NSButton) {
        exit(0)
    }

    func close() {
        popover?.performClose(nil)
    }
}

