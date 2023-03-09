//
//  UserModel.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

struct UserModel: Codable {
    let username: String?
    let phoneNumber: String?
    let email: String?
    let password: String?
    let profilePicture: String?
    let isVerified: Bool?
    let notificationToken: String?
    let notifications: [Notification]?
    let savedProducts: [Product]?
    let otp: Int?
    let countryCode: String?
    let token: String?

    enum CodingKeys: String, CodingKey {
        case username
        case phoneNumber
        case email
        case password
        case profilePicture
        case isVerified
        case notificationToken
        case notifications
        case savedProducts
        case otp
        case countryCode
        case token
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
        isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified)
        notificationToken = try container.decodeIfPresent(String.self, forKey: .notificationToken)
        notifications = try container.decodeIfPresent([Notification].self, forKey: .notifications)
        savedProducts = try container.decodeIfPresent([Product].self, forKey: .savedProducts)
        otp = try container.decodeIfPresent(Int.self, forKey: .otp)
        countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        token = try container.decodeIfPresent(String.self, forKey: .token)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(username, forKey: .username)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encodeIfPresent(profilePicture, forKey: .profilePicture)
        try container.encodeIfPresent(isVerified, forKey: .isVerified)
        try container.encodeIfPresent(notificationToken, forKey: .notificationToken)
        try container.encodeIfPresent(notifications, forKey: .notifications)
        try container.encodeIfPresent(savedProducts, forKey: .savedProducts)
        try container.encodeIfPresent(otp, forKey: .otp)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(token, forKey: .token)
    }
}


