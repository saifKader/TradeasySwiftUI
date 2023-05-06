// TimeAgo.swift
// tradeasy
//
// Created by abdelkader seif eddine on 6/5/2023.
//

// TimeAgo.swift
// tradeasy
//
// Created by abdelkader seif eddine on 6/5/2023.
//

import Foundation



func getTimeAgo(time: Int) -> String? {
    let SECOND_MILLIS = 1_000
    let MINUTE_MILLIS = 60 * SECOND_MILLIS
    let HOUR_MILLIS = 60 * MINUTE_MILLIS
    let DAY_MILLIS = 24 * HOUR_MILLIS
    let WEEK_MILLIS = 7 * DAY_MILLIS
    var timeAgo = time

    if timeAgo < 1_000_000_000 {
        timeAgo *= 1_000
    }

    let now = Int(Date().timeIntervalSince1970 * 1_000)
    if timeAgo > now || timeAgo <= 0 {
        return nil
    }

    let diff = now - timeAgo
    switch diff {
    case 0..<MINUTE_MILLIS:
        return "just now"
    case MINUTE_MILLIS..<2 * MINUTE_MILLIS:
        return "1m ago"
    case 2 * MINUTE_MILLIS..<50 * MINUTE_MILLIS:
        return "\(Int(diff / MINUTE_MILLIS))m ago"
    case 50 * MINUTE_MILLIS..<90 * MINUTE_MILLIS:
        return "1h ago"
    case 90 * MINUTE_MILLIS..<24 * HOUR_MILLIS:
        let hours = Int(diff / HOUR_MILLIS)
        return hours == 1 ? "1h ago" : "\(hours)h ago"
    case 24 * HOUR_MILLIS..<48 * HOUR_MILLIS:
        return "1d ago"
    default:
        let weeks = Int(diff / WEEK_MILLIS)
        return weeks == 1 ? "1w ago" : "\(weeks)w ago"
    }
}
