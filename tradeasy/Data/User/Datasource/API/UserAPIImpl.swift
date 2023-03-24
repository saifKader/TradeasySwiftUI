//
//  UserAPIImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation

struct UserAPIImpl: IUserDataSource {
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
}
