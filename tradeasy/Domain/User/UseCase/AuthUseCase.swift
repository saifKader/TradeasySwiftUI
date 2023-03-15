//
//  AuthUseCase.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

enum UseCaseError: Error {
    case networkError, decodingError, error(message: String)
}

protocol Register {
    func execute(_registerReq: RegisterReq) async -> Result<UserModel, UseCaseError>
}
protocol Login {
    func execute(_loginReq: LoginReq) async -> Result<UserModel, UseCaseError>
}

import Foundation

struct RegisterUseCase: Register {
    var repo: IAuthRepository
    
    func execute(_registerReq: RegisterReq) async -> Result<UserModel, UseCaseError> {
        do {
            let register = try await repo.register(_registerReq:_registerReq)
            return .success(register)
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

struct LoginUseCase: Login {
    var repo: IAuthRepository
    
    func execute(_loginReq: LoginReq) async -> Result<UserModel, UseCaseError> {
        do {
            let login = try await repo.login(_loginReq: _loginReq)
            return .success(login)
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
