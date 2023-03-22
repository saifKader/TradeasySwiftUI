//
//  ErrorFromResponseData.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation

enum APIServiceError: Error {
    case badUrl, requestError, decodingError, statusNotOK(message: String)
}
func errorFromResponseData(_ data: Data) -> APIServiceError {
    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
    let message = (jsonData as? [String: Any])?["message"] as? String ?? "Unknown error occurred."
    return APIServiceError.statusNotOK(message: message)
}
