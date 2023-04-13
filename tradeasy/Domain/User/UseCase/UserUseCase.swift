//
//  UserUseCase.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation

import SwiftUI
protocol ForgotPassword {
    func execute(_ forgetPasswordReq: ForgetPasswordReq) async -> Result<Void, UseCaseError>
}

protocol ResetPassword {
    func execute(_ resetPasswordReq: ResetPasswordReq) async -> Result<Void, UseCaseError>
}

protocol VerifyOtp {
    func execute(_ verifyOtpReq: VerifyOtpReq) async -> Result<Void, UseCaseError>
}

protocol UpdateUsername {
    func execute(username: String) async -> Result<UserModel, UseCaseError>
}
protocol UpdatePassword {
    func execute(currentPassword: String,newPassword: String) async -> Result<UserModel, UseCaseError>
}
protocol SendEmailVerification {
    func sendEmailVerification(_ forgetPasswordReq: ForgetPasswordReq) async -> Result<Void, UseCaseError>
}
protocol ChangeEmail {
    func changeEmail(_ changeEmailReq: ChangeEmailReq) async -> Result<UserModel, UseCaseError>
}

protocol uploadProfilePicure {
    func uploadProfilePicture(_ image: UIImage)  async -> Result<UserModel, UseCaseError>
}
protocol AddToSavedItems {
    func addToSavedItems(_ product_id: String) async throws -> UserModel
}
protocol GetCurrentUserData {
    func getCurrentUser() async throws -> UserModel // Change the return type to UserModel
}

struct UserUseCase: ForgotPassword, ResetPassword, VerifyOtp , UpdateUsername,SendEmailVerification, ChangeEmail,uploadProfilePicure, AddToSavedItems, GetCurrentUserData{
 
  
    
    var repo: IUserRepository
    
    func getCurrentUser() async throws -> UserModel {
        do {
            let userModel = try await repo.getCurrentUser()
            UserPreferences().setUser(user: userModel)
            return userModel
        } catch {
            throw UseCaseError.networkError
        }
    }

    

    
    func addToSavedItems(_ product_id: String) async throws -> UserModel {
           do {
               let userModel = try await repo.addToSavedItems(product_id)
               return userModel
           } catch(let error as APIServiceError) {
               switch(error) {
               case .statusNotOK(let message):
                   throw UseCaseError.error(message: message)
               default:
                   throw UseCaseError.networkError
               }
           } catch {
               throw UseCaseError.networkError
           }
       }
    
    func execute(_ forgetPasswordReq: ForgetPasswordReq) async -> Result<Void, UseCaseError> {
        do {
            try await repo.forgotPassword(forgetPasswordReq)
            return .success(())
        } catch let error as APIServiceError {
            switch error {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    
    func execute(_ resetPasswordReq: ResetPasswordReq) async -> Result<Void, UseCaseError> {
        do {
            try await repo.resetPassword(resetPasswordReq)
            return .success(())
        } catch let error as APIServiceError {
            switch error {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    
    func execute(_ verifyOtpReq: VerifyOtpReq) async -> Result<Void, UseCaseError> {
        do {
            try await repo.verifyOtp(verifyOtpReq)
            return .success(())
        } catch let error as APIServiceError {
            switch error {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    func execute(username: String) async -> Result<UserModel, UseCaseError> {
        do {
            let updateUsername = try await repo.updateUsername(username)
            return .success(updateUsername)
        } catch(let error as APIServiceError) {
            switch(error) {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    func execute(currentPassword: String,newPassword: String) async -> Result<UserModel, UseCaseError> {
        do {
            let updatePassword = try await repo.updatePassword(currentPassword, newPassword)
            return .success(updatePassword)
        } catch(let error as APIServiceError) {
            switch(error) {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    func sendEmailVerification(_ forgetPasswordReq: ForgetPasswordReq) async -> Result<Void, UseCaseError> {
        do {
            try await repo.sendVerificationEmail(forgetPasswordReq)
            return .success(())
        } catch let error as APIServiceError {
            switch error {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    func changeEmail(_ changeEmailReq: ChangeEmailReq) async -> Result<UserModel, UseCaseError> {
        do {
            let userModel = try await repo.changeEmail(changeEmailReq)
            return .success(userModel)
        } catch(let error as APIServiceError) {
            switch(error) {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    
    
    func uploadProfilePicture(_ image: UIImage) async -> Result<UserModel, UseCaseError> {
        do {
            let userModel = try await repo.uploadProfilePicture(image)
            return .success(userModel)
        } catch(let error as APIServiceError) {
            switch(error) {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
  
    
}
    
