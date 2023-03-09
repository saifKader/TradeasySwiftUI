//
//  UserAPIImpl.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

enum APIServiceError: Error{
    case badUrl, requestError, decodingError, statusNotOK,emailAlreadyExist
}

struct UserAPIImpl: UserDataSource {
    let baseUrl: String = "http://192.168.0.25:9090/user"

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
        let code = httpResponse?.statusCode
                if(code != 201) {
                    if(code == 423){
                        throw APIServiceError.emailAlreadyExist
                    }
            throw APIServiceError.statusNotOK
        }

        let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        let token = jsonData["token"] as? String
        let userData = jsonData["data"] as? [String: Any] ?? [:]

           var userModel = try JSONDecoder().decode(UserModel.self, from: JSONSerialization.data(withJSONObject: userData))
           userModel.token = token

           return userModel
    }
}
