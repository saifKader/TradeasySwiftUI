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


struct UserUseCase: ForgotPassword, ResetPassword, VerifyOtp {
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
}
