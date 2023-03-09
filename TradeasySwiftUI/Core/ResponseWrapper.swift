//
//  ResponseWrapper.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

struct WrappedResponse<T: Codable>: Codable {
    let code: Int
    let message: String
    let status: Bool
    let errors: [String]?
    let data: T?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case code, message, status, errors, data, token
    }
}

