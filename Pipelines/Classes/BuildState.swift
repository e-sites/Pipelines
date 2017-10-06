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
    case canceled

    init(from buildState: BuildStates) {
        switch buildState {
        case .failed:
            self = .failed

        case .canceled:
            self = .canceled

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

    var title: String {
        switch self {
        case .empty:
            return ""
        case .failed:
            return "Failed"
        case .passed:
            return "Passed"
        case .scheduled:
            return "Scheduled"
        case .running:
            return "Running"
        case .canceled:
            return "Canceled"
        }
    }
}
