//
//  StatusIcon.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 28/09/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation
import Macaw
import Cocoa
import Apollo

enum BuildState: String {
    case empty
    case failed
    case passed
    case scheduled
    case running

    init(from buildState: BuildStates) {
        switch buildState {
        case .failed, .canceled:
            self = .failed

        case .scheduled:
            self = .scheduled

        case .running, .canceling:
            self = .running

        case .passed:
            self = .passed

        default:
            self = .empty
        }
    }
}

class StatusIconView: NSView {
    lazy private var _statusView: SVGView = {
        let frame = NSRect(x: 3, y: 1, width: 17, height: 17)
        let v = SVGView(frame: frame)
        v.contentMode = .scaleAspectFit
        v.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        v.backgroundColor = MColor.clear
        v.wantsLayer = true
        v.layer?.backgroundColor = NSColor.clear.cgColor
        v.layer?.masksToBounds = false
        return v
    }()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.addSubview(_statusView)
        _updateState()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var state: BuildState = .empty {
        didSet {
            if oldValue == state {
                return
            }
            _updateState(oldValue: oldValue)
        }
    }

    fileprivate func _updateState(oldValue: BuildState? = nil) {
        defer {
            _statusView.fileName = state.rawValue
        }
        if oldValue == .scheduled && state == .running {
            return
        }
        _statusView.layer?.removeAllAnimations()
        alphaValue = 1.0
            switch state {
        case .empty:
            alphaValue = 0.25
        case .running, .scheduled:
            _rotate()
        default:
            break
        }
    }

    fileprivate func _rotate() {
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        basicAnimation.fromValue = 0
        basicAnimation.toValue = Double(360) * .pi / 180
        basicAnimation.duration = 1
        basicAnimation.repeatCount = .infinity
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fillMode = kCAFillModeForwards

        _statusView.layer?.addAnimation(basicAnimation, forKey: "rotate", withCompletion: nil)
    }
}
