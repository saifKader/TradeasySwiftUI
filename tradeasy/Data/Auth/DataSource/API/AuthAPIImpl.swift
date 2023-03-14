//
//  AuthAPIImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation
import Combine

enum APIServiceError: Error {
    case badUrl, requestError, decodingError, statusNotOK(message: String)
}
func errorFromResponseData(_ data: Data) -> APIServiceError {
    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
    let message = (jsonData as? [String: Any])?["message"] as? String ?? "Unknown error occurred."
    return APIServiceError.statusNotOK(message: message)
}


struct AuthAPIImpl: IAuthDataSource {
    
    let baseUrl: String = "http://192.168.0.9:9090/user"
    
    func login(_loginReq: LoginReq) async throws -> UserModel {
        guard let url = URL(string: "\(baseUrl)/login") else {
            throw APIServiceError.badUrl
        }
   var request = URLRequest(url: url)
   request.httpMethod = "POST"
   request.addValue("application/json", forHTTPHeaderField: "Content-Type")
   let requestBody = LoginReq(
       username: _loginReq.username,
       password: _loginReq.password
   )

   let jsonBody = try JSONEncoder().encode(requestBody)
   request.httpBody = jsonBody
   let (data, response) = try await URLSession.shared.data(for: request)
   let httpResponse = response as? HTTPURLResponse
   let code = httpResponse?.statusCode ?? 0
   if code != 201 {

       throw errorFromResponseData(data)
   }
   let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        
   let token = jsonData["token"] as? String
   let userData = jsonData["data"] as? [String: Any] ?? [:]

   var userModel = try JSONDecoder().decode(UserModel.self, from: JSONSerialization.data(withJSONObject: userData))
   userModel.token = token

   return userModel
    }
    
    
   
    
    
    
         func register(_registerReq: RegisterReq) async throws -> UserModel {
             guard let url = URL(string: "\(baseUrl)/register") else {
                 throw APIServiceError.badUrl
             }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody = RegisterReq(
            username: _registerReq.username,
            countryCode: _registerReq.countryCode,
            phoneNumber: _registerReq.phoneNumber,
            email: _registerReq.email,
            password: _registerReq.password
        )

        let jsonBody = try JSONEncoder().encode(requestBody)
        request.httpBody = jsonBody
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse
        let code = httpResponse?.statusCode ?? 0
        if code != 201 {

            throw errorFromResponseData(data)
        }
        let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
             
        let token = jsonData["token"] as? String
        let userData = jsonData["data"] as? [String: Any] ?? [:]

        var userModel = try JSONDecoder().decode(UserModel.self, from: JSONSerialization.data(withJSONObject: userData))
        userModel.token = token

        return userModel
    }
}

