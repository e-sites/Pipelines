//
//  PopupView.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 06/10/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation
import AppKit
import EasyPeasy

class PopupView: NSView {
    override func viewDidMoveToWindow() {

        guard let frameView = window?.contentView?.superview else {
            return
        }

        let backgroundView = NSView(frame: frameView.bounds)
        backgroundView.wantsLayer = true
        backgroundView.layer?.backgroundColor = NSColor(calibratedWhite: 0.92, alpha: 1).cgColor
        frameView.addSubview(backgroundView, positioned: .below, relativeTo: frameView)
        backgroundView <- Edges()
    }
}
