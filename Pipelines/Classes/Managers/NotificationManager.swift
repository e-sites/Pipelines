//
//  NotificationManager.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 29/09/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation
import NotificationCenter
import Macaw
import SwiftyUserDefaults
import Apollo

extension DefaultsKeys {
    fileprivate static let deliveredNotifications = DefaultsKey<[String]>("deliveredNotifications")
}

class NotificationManager {
    static let `default` = NotificationManager()

    private init() {

    }

    fileprivate func _notificationIdentifier(`for` node: Build) -> String {
        var buildState = BuildState(from: node.state)
        if buildState == .scheduled || buildState == .empty {
            buildState = .running
        }
        return node.id + buildState.rawValue
    }

    func hasNotificationBeenTriggered(`for` node: Build) -> Bool {
        let identifier = _notificationIdentifier(for: node)
        return Defaults[.deliveredNotifications].contains(identifier)
    }

    func triggerLocalNotification(`for` node: Build) {
        if hasNotificationBeenTriggered(for: node) {
            return
        }
        guard let pipeline = node.pipeline?.name else {
            return
        }
        let identifier = _notificationIdentifier(for: node)
        Defaults[.deliveredNotifications].append(identifier)

        let notification = NSUserNotification()

        let buildState = BuildState(from: node.state)
        var svgImage: String? = buildState.rawValue
        switch buildState {
        case .passed:
            notification.title = "Build is passed!"
            
        case .failed:
            notification.title = "Build is failed!"

        case .canceled:
            notification.title = "Build is canceled!"

        default:
            notification.title = "New build"
            svgImage = nil
        }

        if let icon = svgImage {
            let frame = NSRect(x: 0, y: 0, width: 128, height: 128)
            let v = SVGView(frame: frame)
            v.contentMode = .scaleAspectFit
            v.backgroundColor = MColor.clear
            v.fileName = icon
            notification.contentImage = v.image()
        }

        notification.subtitle = pipeline.emojiRendered
        notification.informativeText = node.message.emojiRendered
        NSUserNotificationCenter.default.deliver(notification)
    }
}
