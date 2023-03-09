//
//  UserAPIImpl.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

enum APIServiceError: Error{
    case badUrl, requestError, decodingError, statusNotOK
}

struct UserAPIImpl: UserDataSource {
  
let baseUrl:String = "http://192.168.0.25:9090/user"
    func register(_registerReq: RegisterReq) async throws -> UserModel {
        guard let url = URL(string: "\(baseUrl)/register") else {
            throw APIServiceError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = RegisterReq(username: _registerReq.username, countryCode: _registerReq.countryCode, phoneNumber: _registerReq.phoneNumber, email: _registerReq.email, password: _registerReq.password)
        do {
            let jsonBody = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonBody
        } catch {
            throw APIServiceError.requestError
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw APIServiceError.statusNotOK
        }
        
        do {
            let userModel = try JSONDecoder().decode(UserModel.self, from: data)
            print("user model\(userModel)")
            return userModel
        } catch {
            throw APIServiceError.decodingError
        }
        
    }
}
