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
        
        @Provider var userDataSource = UserAPIImpl() as IUserDataSource
        @Provider var userRepository = UserRepositoryImpl(dataSource: userDataSource) as IUserRepository
        
        @Provider var productDataSource = ProductAPI() // Create an instance of ProductAPI
        @Provider var productRepository = ProductRepositoryImpl(productApi: productDataSource) as IProductRepository

        
        
        
    }
}

