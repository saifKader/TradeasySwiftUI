//
//  UserDataSource.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation

protocol IUserDataSource {
    func forgotPassword(_ forgetPasswordReq: ForgetPasswordReq) async throws
    func resetPassword(_ resetPasswordReq: ResetPasswordReq) async throws
    func verifyOtp(_ verifyOtpReq: VerifyOtpReq) async throws
    func updateUsername(_ username: String) async throws -> UserModel
    func updatePassword(_ currentPassword: String,_ newPassword: String) async throws -> UserModel
    func sendVerificationEmail(_ forgetPasswordReq: ForgetPasswordReq) async throws
    func changeEmail(_ changeEmailReq: ChangeEmailReq) async throws -> UserModel
   
}

