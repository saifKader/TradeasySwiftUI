//
//  RegisterReq.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

struct RegisterReq: Codable {
    let username: String
    let countryCode: String
    let phoneNumber: String
    let email: String
    let password: String
}
