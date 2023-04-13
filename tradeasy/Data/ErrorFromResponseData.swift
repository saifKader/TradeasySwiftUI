//
//  ErrorFromResponseData.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation

enum APIServiceError: Error {
    case badUrl, requestError, decodingError, statusNotOK(message: String), unknownError, invalidUserToken
}

struct APIErrorResponse: Codable {
    let message: String
}

func errorFromResponseData(_ data: Data) -> APIServiceError {
    do {
        let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
        return .statusNotOK(message: errorResponse.message)
    } catch {
        print("Failed to decode error response using Codable: \(error)")
        
        if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
           let message = (jsonData as? [String: Any])?["message"] as? String {
            return APIServiceError.statusNotOK(message: message)
        } else {
            print("Failed to decode error response using JSONSerialization.")
            //print("Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string.")")
            return .unknownError
        }
    }
}



struct ForgetPasswordResponse {
    let success: Bool
    let errorMessage: String?
    let userData: Any?
}

