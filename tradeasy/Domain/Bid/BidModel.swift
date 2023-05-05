//
//  BidModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation
import Combine

class BidModel: Codable, ObservableObject {
    let _id: String?
    let user_id: String
    let product_id: String
    let bid_amount: Float
    let socket_id: String
    let createdAt: String?
    let updatedAt: String?
    var bids: [Bid]?
    enum CodingKeys: String, CodingKey {
        case _id
        case user_id = "user"
        case product_id
        case bid_amount
        case socket_id
        case createdAt
        case updatedAt
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decodeIfPresent(String.self, forKey: ._id)
        user_id = try container.decode(String.self, forKey: .user_id)
        product_id = try container.decode(String.self, forKey: .product_id)
        bid_amount = try container.decode(Float.self, forKey: .bid_amount)
        socket_id = try container.decode(String.self, forKey: .socket_id)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_id, forKey: ._id)
        try container.encode(user_id, forKey: .user_id)
        try container.encode(product_id, forKey: .product_id)
        try container.encode(bid_amount, forKey: .bid_amount)
        try container.encode(socket_id, forKey: .socket_id)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
}
