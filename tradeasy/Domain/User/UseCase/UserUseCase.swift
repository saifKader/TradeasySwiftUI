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
    func sendEmailVerification(_ forgetPasswordReq: ForgetPasswordReq) async -> Result<UserModel, UseCaseError>
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
protocol VerifyAccount {
    func sendVerificationSms() async throws -> Result<Void, UseCaseError> // Change the return type to UserModel
}
protocol VerifyAccountOTP{
    func verifyAccountOTP(otp: String) async -> Result<UserModel, UseCaseError>
}
protocol ChangePhoneNumber {
    func changePhoneNumber(_ changePhoneNumberReq: ChangePhoneNumberReq) async -> Result<UserModel, UseCaseError>
}

struct UserUseCase: ForgotPassword, ResetPassword, VerifyOtp , UpdateUsername,SendEmailVerification, ChangeEmail,uploadProfilePicure, AddToSavedItems, GetCurrentUserData,VerifyAccount,VerifyAccountOTP,ChangePhoneNumber{

    
    
   
    var repo: IUserRepository
    
    func sendEmailVerification(_ forgetPasswordReq: ForgetPasswordReq) async -> Result<UserModel, UseCaseError> {
        do {
            let userModel =  try await repo.sendVerificationEmail(forgetPasswordReq)
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
    
    func getCurrentUser() async throws -> UserModel {
        do {
            let userModel = try await repo.getCurrentUser()
            UserPreferences().setUser(user: userModel)
            return userModel
        } catch {
            throw UseCaseError.networkError
        }
    }


    func sendVerificationSms() async-> Result<Void, UseCaseError> {
        do {
            try await repo.sendSmsToVerifyAccount()
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
    func verifyAccountOTP(otp: String) async -> Result<UserModel, UseCaseError> {
        do {
            print(otp)
            let otp = try await repo.verifyAccount(otp)
            print("ahawa1\(otp)")
            return .success(otp)
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
    func changePhoneNumber(_ changePhoneNumberReq: ChangePhoneNumberReq) async -> Result<UserModel, UseCaseError> {
        do {
            let userModel = try await repo.changePhoneNumber(changePhoneNumberReq)
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
    
