//
//  ChangeEmailReq.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 6/4/2023.
//

import Foundation

struct ChangeEmailReq: Encodable {
    let otp: String
    let newEmail: String
}
