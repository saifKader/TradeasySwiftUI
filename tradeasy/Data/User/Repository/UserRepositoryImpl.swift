//
//  UserRepositoryImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation
import UIKit

struct UserRepositoryImpl: IUserRepository {

    var dataSource: UserAPI
    
    func forgotPassword(_ forgetPasswordReq: ForgetPasswordReq) async throws {
        try await dataSource.forgotPassword(forgetPasswordReq)
    }
    
    func resetPassword(_ resetPasswordReq: ResetPasswordReq) async throws {
        try await dataSource.resetPassword(resetPasswordReq)
    }
    
    func verifyOtp(_ verifyOtpReq: VerifyOtpReq) async throws {
        try await dataSource.verifyOtp(verifyOtpReq)
    }
    
    func updateUsername(_ username: String) async throws -> UserModel {
        try await dataSource.updateUsername(username)
    }
  
    func updatePassword(_ currentPassword: String, _ newPassword: String) async throws -> UserModel {
        try await dataSource.updatePassword(currentPassword, newPassword)
    }
    
    func sendVerificationEmail (_ forgetPasswordReq:ForgetPasswordReq) async throws -> UserModel {
        try await dataSource.sendVerificationEmail(forgetPasswordReq)
    }
    
    func changeEmail(_ changeEmailReq: ChangeEmailReq) async throws -> UserModel {
        return try await dataSource.changeEmail(changeEmailReq)
    }
    
    func uploadProfilePicture(_ image: UIImage) async throws -> UserModel {
        return try await dataSource.uploadProfilePicture(image)
    }
    
    func addToSavedItems(_ product_id: String) async throws -> UserModel {
        return try await dataSource.addToSavedItems(product_id)
    }
    func getCurrentUser() async throws -> UserModel {
        return try await dataSource.getCurrentUser()
    }
}
