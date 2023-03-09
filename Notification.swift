//
//  Notification.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation


struct Notification: Codable {
    let title: String?
    let description: String?
    let date: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String?.self, forKey: .title)
        description = try container.decode(String?.self, forKey: .description)
        date = try container.decode(Int?.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(date, forKey: .date)
    }
}
