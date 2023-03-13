//
//  UserRepositoryImpl.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation
import Combine

struct UserRepositoryImpl: UserRepository{
    var dataSource: UserDataSource
    
    
    
    func register(_registerReq: RegisterReq) async throws -> UserModel {
        let _register =  try await dataSource.register(_registerReq: _registerReq)
        return _register
    }
}
