//
//  DI.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation

class InitDepedencyInjection{
    init(){
        @Provider var authDataSource = AuthAPIImpl()
        @Provider var authRepository = AuthRepositoryImpl(dataSource: authDataSource) as IAuthRepository
        
        @Provider var userDataSource = UserAPI()
        @Provider var userRepository = UserRepositoryImpl(dataSource: userDataSource) as IUserRepository
        
        @Provider var productDataSource = ProductAPI() // Create an instance of ProductAPI
        @Provider var productRepository = ProductRepositoryImpl(productApi: productDataSource) as IProductRepository
        @Provider var categoryDataSource = CategoryAPI() // Create an instance of ProductAPI
        @Provider var categoryRepository = CategoryRepositoryImpl(categoryApi: categoryDataSource) as ICategoryRepository


        
        
        
    }
}

