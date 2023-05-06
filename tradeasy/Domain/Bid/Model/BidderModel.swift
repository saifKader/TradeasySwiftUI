//
//  BidderModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation
import Combine

class BidderModel: Codable, ObservableObject, Hashable, Equatable {
    let _id: String?
    let user: String
    let product: String
    let userName: String
    let userProfilePic: String
    let bidAmount: Float
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case _id
        case user
        case product
        case userName
        case userProfilePic
        case bidAmount
        case createdAt
        case updatedAt
    }
    init(id: String, userName: String, userProfilePic: String, bidAmount: Float) {
        self._id = id
        self.user = ""
        self.product = ""
        self.userName = userName
        self.userProfilePic = userProfilePic
        self.bidAmount = bidAmount
        self.createdAt = nil
        self.updatedAt = nil
    }
    func hash(into hasher: inout Hasher) {
            hasher.combine(_id)
        }

        // Conformance to Equatable
        static func == (lhs: BidderModel, rhs: BidderModel) -> Bool {
            return lhs._id == rhs._id
        }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decodeIfPresent(String.self, forKey: ._id)
        user = try container.decode(String.self, forKey: .user)
        product = try container.decode(String.self, forKey: .product)
        userName = try container.decode(String.self, forKey: .userName)
        userProfilePic = try container.decode(String.self, forKey: .userProfilePic)
        bidAmount = try container.decode(Float.self, forKey: .bidAmount)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_id, forKey: ._id)
        try container.encode(user, forKey: .user)
        try container.encode(product, forKey: .product)
        try container.encode(userName, forKey: .userName)
        try container.encode(userProfilePic, forKey: .userProfilePic)
        try container.encode(bidAmount, forKey: .bidAmount)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
}

