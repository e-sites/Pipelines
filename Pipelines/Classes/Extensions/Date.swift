//
//  Date.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 06/10/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation

extension Date {
    func timeAgoReadable() -> String {
        let calendar = NSCalendar.current

        let now = Date()
        let earliest = now < self ? now : self
        let latest = (earliest == now) ? self : now

        let components = calendar.dateComponents([ .minute, .hour, .day, .weekOfYear, .month, .year, .second ], from: earliest, to: latest)
        guard let year = components.year, let month = components.month, let weekOfYear = components.weekOfYear, let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second else {
            return ""
        }
        if year >= 2 {
            return "\(year) years ago"

        } else if year >= 1 {
            return "Last year"

        } else if month >= 2 {
            return "\(month) months ago"

        } else if month >= 1 {
            return "Last month"

        } else if weekOfYear >= 2 {
            return "\(weekOfYear) weeks ago"

        } else if weekOfYear >= 1 {
            return "Last week"

        } else if day >= 2 {
            return "\(day) days ago"

        } else if day >= 1 {
            return "Yesterday"

        } else if hour >= 2 {
            return "\(hour) hours ago"

        } else if hour >= 1 {
            return "An hour ago"

        } else if minute >= 2 {
            return "\(minute) minutes ago"

        } else if minute >= 1 {
            return "A minute ago"

        } else if second >= 3 {
            return "\(second) seconds ago"

        } else {
            return "Just now"
        }

    }
}
