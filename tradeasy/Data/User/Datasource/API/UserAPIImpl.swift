//
//  UserAPIImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation
import Alamofire
struct UserAPIImpl: IUserDataSource {
    
    let userPreferences = UserPreferences()
   
    func forgotPassword(_ forgetPasswordReq: ForgetPasswordReq) async throws {
        guard let url = URL(string: "\(kbaseUrl)\(kforgetpassword)") else {
            throw APIServiceError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody = try JSONEncoder().encode(forgetPasswordReq)
        request.httpBody = jsonBody
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse
        let code = httpResponse?.statusCode ?? 0
        if code != 200 {
            throw errorFromResponseData(data)
        }
    }
    
    func resetPassword(_ resetPasswordReq: ResetPasswordReq) async throws {
        guard let url = URL(string: "\(kbaseUrl)\(kresetpassword)") else {
            throw APIServiceError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody = try JSONEncoder().encode(resetPasswordReq)
        request.httpBody = jsonBody
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse
        let code = httpResponse?.statusCode ?? 0
        if code != 200 {
            throw errorFromResponseData(data)
        }
    }
    
    func verifyOtp(_ verifyOtpReq: VerifyOtpReq) async throws {
        guard let url = URL(string: "\(kbaseUrl)\(kverifyotp)") else {
            throw APIServiceError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody = try JSONEncoder().encode(verifyOtpReq)
        request.httpBody = jsonBody
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse
        let code = httpResponse?.statusCode ?? 0
        if code != 200 {
            throw errorFromResponseData(data)
        }
    }
    func updateUsername(_ username: String) async throws -> UserModel {
        let url = "\(kbaseUrl)\(kupdateUsername)"
  
        let headers: HTTPHeaders = ["Content-Type": "application/json", "jwt": (userPreferences.getUser()?.token)!]
        let parameters: [String: Any] = ["username": username]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<202)
                .responseJSON { response in
                    guard response.response?.statusCode != 401 else {
                        continuation.resume(throwing: errorFromResponseData(response.data!))
                        return
                    }

                    switch response.result {
                    case .success(let data):
                        guard let jsonData = data as? [String: Any], let userData = jsonData["data"] as? [String: Any], let token = jsonData["token"] as? String else {
                            continuation.resume(throwing: APIServiceError.decodingError)
                            return
                        }
                        do {
                            var userModel = try JSONDecoder().decode(UserModel.self, from: JSONSerialization.data(withJSONObject: userData))
                            userModel.token = token
                            continuation.resume(returning: userModel)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    func updatePassword(_ currentPassword: String, _ newPassword: String) async throws -> UserModel {
        let userPreferences = UserPreferences()
        let url = "\(kbaseUrl)\(kupdatePassword)"
           
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "jwt": (userPreferences.getUser()?.token)!
        ]

        let parameters: [String: Any] = [
            "currentPassword": currentPassword,
            "newPassword": newPassword
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: headers)
                .validate(statusCode: 200..<202)
                .responseJSON { response in
                    // Check for status code 401
                    if response.response?.statusCode == 401 {
                        print("here1")
                        print(response.data!)
                        continuation.resume(throwing: errorFromResponseData(response.data!))
                        return
                    }

                    switch response.result {
                    case .success(let data):
                        guard let jsonData = data as? [String: Any],
                              let userData = jsonData["data"] as? [String: Any],
                              let token = jsonData["token"] as? String else {
                            continuation.resume(throwing: APIServiceError.decodingError)
                                  return
                              }
                        do {
                            var userModel = try JSONDecoder().decode(UserModel.self, from: JSONSerialization.data(withJSONObject: userData))
                            userModel.token = token
                            continuation.resume(returning: userModel)
                        } catch {
                            print("herrre11")
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
             print("herrre")
        
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func sendVerificationEmail(_ forgetPasswordReq: ForgetPasswordReq) async throws {
            let url = "\(kbaseUrl)\(ksendVerificationEmail)"
            let userPreferences = UserPreferences()
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "jwt": (userPreferences.getUser()?.token)!
            ]
            let jsonBody = try JSONEncoder().encode(forgetPasswordReq)
            return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                AF.upload(jsonBody, to: url, method: .post, headers: headers)
                    .validate(statusCode: 200..<202)
                    .response { (response: AFDataResponse<Data?>) in
                        if let error = response.error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: ())
                        }
                    }
            }
        }
    func changeEmail(_ changeEmailReq: ChangeEmailReq) async throws -> UserModel {
        let url = "\(kbaseUrl)\(kchangeEmail)"
        let userPreferences = UserPreferences()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "jwt": (userPreferences.getUser()?.token)!
        ]
        let jsonBody = try JSONEncoder().encode(changeEmailReq)
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<UserModel, Error>) in
            AF.upload(jsonBody, to: url, method: .post, headers: headers)
                .validate(statusCode: 200..<202)
                .responseDecodable(of: UserModel.self) { response in
                    switch response.result {
                    case .success(let user):
                        continuation.resume(returning: user)
                    case .failure(let error):
                        if let data = response.data {
                            do {
                                throw errorFromResponseData(data)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
}
