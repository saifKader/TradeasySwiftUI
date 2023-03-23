//
//  UserRepository.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation

protocol IUserRepository {
    func forgotPassword(_ forgetPasswordReq: ForgetPasswordReq) async throws -> Void
    func resetPassword(_ resetPasswordReq: ResetPasswordReq) async throws -> Void
    func verifyOtp(_ verifyOtpReq: VerifyOtpReq) async throws -> Void
}

