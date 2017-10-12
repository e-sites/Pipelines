//
//  StatusIcon.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 28/09/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation
import Macaw
import EasyPeasy
import Cocoa

class StatusIconView: NSView {
    lazy private var _statusView: SVGView = {
        let v = SVGView(frame: self.bounds)
        v.wantsLayer = true
        v.contentMode = .scaleAspectFit
        v.backgroundColor = MColor.clear
        v.layer?.backgroundColor = NSColor.clear.cgColor
        v.layer?.masksToBounds = false
        return v
    }()

    var shouldAnimate: Bool = true {
        didSet {
            _updateState(oldValue: nil)
        }
    }

    var state: BuildState = .empty {
        didSet {
            if oldValue == state {
                return
            }
            _updateState(oldValue: oldValue)
        }
    }

    override var frame: NSRect {
        didSet {
            _statusView.layer?.position = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
            _statusView.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.485)
            _statusView.frame = self.bounds
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.addSubview(_statusView)
        _statusView <- Edges()
        _updateState()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func _updateState(oldValue: BuildState? = nil) {
        defer {
            _statusView.fileName = state.rawValue
        }
        let f = frame
        self.frame = f
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
            _rotate()
            break
        }
    }


    fileprivate func _rotate() {
        if !shouldAnimate {
            return
        }
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
