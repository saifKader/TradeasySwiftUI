//
//  UseCaseError.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation

enum UseCaseError: Error {
    case networkError, decodingError, error(message: String)
}

