//
//  UserUseCase.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation


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
struct UserUseCase: ForgotPassword, ResetPassword, VerifyOtp , UpdateUsername,SendEmailVerification, ChangeEmail{
    
    var repo: IUserRepository
    
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
}
    
