//
//  BuildState.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 29/09/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation
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
