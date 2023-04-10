//
//  UserRepositoryImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//

import Foundation
struct ProductRepositoryImpl: IProductRepository {
    
    let productApi : ProductAPI
    
    func searchByName(_ name: ProdNameReq) async throws -> [ProductModel] {
        try await productApi.searchProductByname(name)
    }
    
   
    

   


}

