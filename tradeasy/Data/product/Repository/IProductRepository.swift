//
//  IProductRepository.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//

import Foundation

protocol IProductRepository {
    func searchByName(_ name: ProdNameReq) async throws -> [ProductModel]
 
}

