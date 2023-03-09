//
//  UserRepositoryImpl.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

struct UserRepositoryImpl: UserRepository{
    
    var dataSource: UserDataSource
    
    func register() async throws -> [RegisterModel] {
        let _register =  try await dataSource.register()
        return _register
    }
}
