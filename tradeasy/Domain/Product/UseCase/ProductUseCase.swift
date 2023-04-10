//
//  ProductUseCase.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//

import Foundation


import Foundation


protocol SearchProdByName {
    func searchProdByName(_ seachProdByNameReq : ProdNameReq) async -> Result<[ProductModel], UseCaseError>
}

struct ProductUseCase: SearchProdByName{
   
    
    var repo: IProductRepository
    

    func searchProdByName(_ seachProdByNameReq: ProdNameReq) async -> Result<[ProductModel], UseCaseError> {
        do {
            let products = try await repo.searchByName(seachProdByNameReq)
            return .success(products)
        } catch(let error as APIServiceError) {
            switch(error) {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
}
    
