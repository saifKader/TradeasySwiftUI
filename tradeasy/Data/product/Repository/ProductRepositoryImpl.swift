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
    func addProduct(_ addProductReq: AddProductReq) async throws -> ProductModel {
           try await productApi.addProduct(addProductReq)
       }
    func getAllProducts() async throws -> [ProductModel] {
         let products = try await productApi.getAllProducts()
         return products
     }
 

}

