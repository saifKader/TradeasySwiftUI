//
//  UserRepository.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation
import SwiftUI

protocol IUserRepository {
    func forgotPassword(_ forgetPasswordReq: ForgetPasswordReq) async throws -> Void
    func resetPassword(_ resetPasswordReq: ResetPasswordReq) async throws -> Void
    func verifyOtp(_ verifyOtpReq: VerifyOtpReq) async throws -> Void
    func updateUsername(_ username: String) async throws -> UserModel
    func updatePassword(_ currentPassword: String, _ newPassword: String) async throws -> UserModel
    func sendVerificationEmail(_ forgetPasswordReq: ForgetPasswordReq) async throws -> Void
    func changeEmail(_ changeEmailReq: ChangeEmailReq) async throws -> UserModel
    func uploadProfilePicture(_ image: UIImage) async throws -> UserModel
    func addToSavedItems(_ product_id: String) async throws -> UserModel
    func getCurrentUser() async throws -> UserModel 
}


