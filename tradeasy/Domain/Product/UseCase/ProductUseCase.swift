//
//  ProductUseCase.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//

import Foundation

protocol SearchProdByName {
    func searchProdByName(_ seachProdByNameReq : ProdNameReq) async -> Result<[ProductModel], UseCaseError>
}
protocol AddProd {
    func addProduct(_ addProductReq: AddProductReq) async -> Result<ProductModel, UseCaseError>
}
protocol GetAllProducts {
    func getAllProducts() async -> Result<[ProductModel], UseCaseError>
}
struct ProductUseCase: SearchProdByName, AddProd, GetAllProducts{
    var repo: IProductRepository
    
    func getAllProducts() async -> Result<[ProductModel], UseCaseError> {
        do {
            let products = try await repo.getAllProducts()
            print("Products retrieved: \(products)") // Add this print statement
            return .success(products)
        } catch(let error as APIServiceError) {
            print("API Service Error: \(error.localizedDescription)") // Add this print statement
            switch(error) {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            print("Unknown error: \(error.localizedDescription)") // Add this print statement
            return .failure(.networkError)
        }
    }

   
    

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
    
    func addProduct(_ addProductReq: AddProductReq) async -> Result<ProductModel, UseCaseError> {
        do {
                   let product = try await repo.addProduct(addProductReq)
                   return .success(product)
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
    
