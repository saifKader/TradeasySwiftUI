//
//  AuthRepoImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation
import Combine

struct AuthRepositoryImpl: IAuthRepository{
    var dataSource: IAuthDataSource
    
    
    
    func register(_registerReq: RegisterReq) async throws -> UserModel {
        let _register =  try await dataSource.register(_registerReq: _registerReq)
        return _register
    }
    func login(_loginReq: LoginReq) async throws -> UserModel {
        let _loginReq =  try await dataSource.login(_loginReq: _loginReq)
        return _loginReq
    }
    
}

