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
}
