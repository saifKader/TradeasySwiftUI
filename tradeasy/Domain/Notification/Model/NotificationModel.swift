//
//  NotificationModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//
import Foundation
import CoreData

struct NotificationModel: Codable, Identifiable, Hashable {
    let id: String
    let title: String?
    let description: String?
    let date: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case date
    }

    // Custom initializer
    init(id: String, title: String?, description: String?, date: Int?) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String?.self, forKey: .title)
        description = try container.decode(String?.self, forKey: .description)
        date = try container.decode(Int?.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(date, forKey: .date)
    }
}
