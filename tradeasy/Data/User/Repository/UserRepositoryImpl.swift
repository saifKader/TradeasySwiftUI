//
//  UserRepositoryImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation


struct UserRepositoryImpl: IUserRepository {
    var dataSource: IUserDataSource
    
    func forgotPassword(_ forgetPasswordReq: ForgetPasswordReq) async throws {
        try await dataSource.forgotPassword(forgetPasswordReq)
    }
    
    func resetPassword(_ resetPasswordReq: ResetPasswordReq) async throws {
        try await dataSource.resetPassword(resetPasswordReq)
    }
    
    func verifyOtp(_ verifyOtpReq: VerifyOtpReq) async throws {
        try await dataSource.verifyOtp(verifyOtpReq)
    }
}

