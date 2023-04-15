//
//  IProductRepository.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//

import Foundation

protocol IProductRepository {
    func searchByName(_ name: ProdNameReq) async throws -> [ProductModel]
    func addProduct(_ addProductReq: AddProductReq) async throws -> ProductModel
    func getAllProducts() async throws -> [ProductModel]
    func getUserProducts() async throws -> [ProductModel]
    func productListOrUnlist(_ unlistProductReq: UnlistProductReq) async throws -> Bool
}



