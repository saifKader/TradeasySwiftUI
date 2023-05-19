//
//  RegisterReq.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//


import Foundation

struct RegisterReq: Codable {
    let username: String
    let countryCode: String
    let phoneNumber: String
    let email: String
    let password: String
}

struct FirebaseRegisterReq : Codable {
    let username: String
    let countryCode: String
    let phoneNumber: String
    let email: String
    let profilePicture : String
}
