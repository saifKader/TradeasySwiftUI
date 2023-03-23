//
//  ResetPasswordReq.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation

struct ResetPasswordReq: Codable {
    let email:String
    let otp:String
    let password:String
}
