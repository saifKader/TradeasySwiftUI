//
//  ProductModel.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

struct Product: Codable {
    let userId: String?
    let category: String?
    let name: String?
    let description: String?
    let price: Float?
    let image: [String]?
    let quantity: Int?
    let addedDate: Int?
    let forBid: Bool?
    let bidEndDate: Int?
    let bade: Bool?
    let sold: Bool?
    let username: String?
    let userPhoneNumber: String?
    let userProfilePicture: String?
    let selling: Bool?
    let productId: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case category
        case name
        case description
        case price
        case image
        case quantity
        case addedDate
        case forBid
        case bidEndDate
        case bade
        case sold
        case username
        case userPhoneNumber
        case userProfilePicture
        case selling
        case productId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        price = try container.decodeIfPresent(Float.self, forKey: .price)
        image = try container.decodeIfPresent([String].self, forKey: .image)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        addedDate = try container.decodeIfPresent(Int.self, forKey: .addedDate)
        forBid = try container.decodeIfPresent(Bool.self, forKey: .forBid)
        bidEndDate = try container.decodeIfPresent(Int.self, forKey: .bidEndDate)
        bade = try container.decodeIfPresent(Bool.self, forKey: .bade)
        sold = try container.decodeIfPresent(Bool.self, forKey: .sold)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        userPhoneNumber = try container.decodeIfPresent(String.self, forKey: .userPhoneNumber)
        userProfilePicture = try container.decodeIfPresent(String.self, forKey: .userProfilePicture)
        selling = try container.decodeIfPresent(Bool.self, forKey: .selling)
        productId = try container.decodeIfPresent(String.self, forKey: .productId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(quantity, forKey: .quantity)
        try container.encodeIfPresent(addedDate, forKey: .addedDate)
        try container.encodeIfPresent(forBid, forKey: .forBid)
        try container.encodeIfPresent(bidEndDate, forKey: .bidEndDate)
        try container.encodeIfPresent(bade, forKey: .bade)
        try container.encodeIfPresent(sold, forKey: .sold)
        try container.encodeIfPresent(username, forKey: .username)
        try container.encodeIfPresent(userPhoneNumber, forKey: .userPhoneNumber)
        try container.encodeIfPresent(userProfilePicture, forKey: .userProfilePicture)
        try container.encodeIfPresent(selling, forKey: .selling)
        try container.encodeIfPresent(productId, forKey: .productId)
    }
}
