//
//  DI.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation

class InitDepedencyInjection{
    init(){
        @Provider var authDataSource = AuthAPIImpl() as IAuthDataSource
        @Provider var authRepository = AuthRepositoryImpl(dataSource: authDataSource) as IAuthRepository
        
        
        
    }
}

