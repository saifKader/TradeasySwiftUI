//
//  AuthAPIImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation
import Combine


struct AuthAPIImpl: IAuthDataSource {

    
    
    func login(_loginReq: LoginReq) async throws -> UserModel {
        guard let url = URL(string: "\(kbaseUrl)\(klogin)") else {
            throw APIServiceError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody = try JSONEncoder().encode(_loginReq)
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
        guard let url = URL(string: "\(kbaseUrl)\(kregister)") else {
            throw APIServiceError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody = try JSONEncoder().encode(_registerReq)
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
    func firebaseRegister(_firebaseRegisterReq: FirebaseRegisterReq) async throws -> UserModel {
        guard let url = URL(string: "\(kbaseUrl)\(kregisterFirebaseUser)") else {
            throw APIServiceError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody = try JSONEncoder().encode(_firebaseRegisterReq)
        request.httpBody = jsonBody
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse
        let code = httpResponse?.statusCode ?? 0
        if code != 201  {
            
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

