//
//  Emojis.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 29/09/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation

fileprivate var _emojiMapping: [String: String] = [
    "mac": "",
    "rocket": "🚀",
    "skull_and_crossbones": "☠️",
    "skull": "💀",
    "helmet_with_white_cross": "⛑️",
    "male_scientist": "👨‍🔬"
]

extension String {

    var emojiRendered: String {

        var str = self
        for key in _emojiMapping.keys {
            str = str.replacingOccurrences(of: ":\(key):", with: _emojiMapping[key]!)
        }
        return str
    }
}
