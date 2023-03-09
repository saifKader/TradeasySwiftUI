//
//  BaseResult.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation
enum BaseResult<T, U> {
    case baseSuccess(data: T)
    case error(rawResponse: U)
}

enum UiState<T> {
    case loading
    case success(data: T)
    case failure(message: String)
}
