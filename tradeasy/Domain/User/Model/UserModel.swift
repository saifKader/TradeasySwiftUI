//
//  UserModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation

struct UserModel: Codable, Equatable {
    let _id: String?
    let username: String?
    let phoneNumber: String?
    let email: String?
    let password: String?
    let profilePicture: String?
    let isVerified: Bool?
    let notificationToken: String?
    let notifications: [Notification]?
    let savedProducts: [ProductModel]?
    let otp: Int?
    let countryCode: String?
    var token: String?
    var isFirebase: Bool?

    enum CodingKeys: String, CodingKey {
        case _id
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
        case isFirebase
    }
    
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decodeIfPresent(String.self, forKey: ._id)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
        isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified)
        notificationToken = try container.decodeIfPresent(String.self, forKey: .notificationToken)
        notifications = try container.decodeIfPresent([Notification].self, forKey: .notifications)
        savedProducts = try container.decodeIfPresent([ProductModel].self, forKey: .savedProducts)
        otp = try container.decodeIfPresent(Int.self, forKey: .otp)
        countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        isFirebase = try container.decodeIfPresent(Bool.self, forKey: .isFirebase)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_id, forKey: ._id)
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
        try container.encodeIfPresent(isFirebase, forKey: .isFirebase)
    }
    static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
            return lhs._id == rhs._id
        }
}



