//
//  AppDelegate.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 28/09/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Cocoa

let fetchBuildsNotification = NSNotification.Name("FetchBuildsNotification")

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    private let statusItem = NSStatusBar.system.statusItem(withLength: 0)
    private let graphQLClient = GraphQLClient()
    private let statusItemManager = StatusItemManager()
    private var _refetchTimer: Timer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItemManager.setup(with: statusItem)
        NotificationCenter.default.addObserver(forName: fetchBuildsNotification, object: nil, queue: nil) { _ in
            self._refetchTimer?.invalidate()
            self._fetch()
        }
        _fetch()
    }
    
    @objc
    private func _fetch() {
        _refetchTimer?.invalidate()
        _refetchTimer = nil
        graphQLClient.getLatestBuilds { nodes in
            let timer = Timer(timeInterval: Constants.fetchInterval, repeats: false) { _ in
                self._fetch()
            }
            RunLoop.main.add(timer, forMode: .commonModes)
            self._refetchTimer = timer
            guard let nodes = nodes else {
                return
            }
            self.statusItemManager.nodes = nodes
        }
    }
}
