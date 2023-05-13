//
//  ChangePhoneNumberReq.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 12/5/2023.
//


import Foundation

struct ChangePhoneNumberReq: Codable {
    let otp: String
    let newPhoneNumber: String
    let countryCode : String


}
