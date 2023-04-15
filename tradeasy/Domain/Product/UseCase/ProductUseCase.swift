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
protocol GetUserProducts {
    func getUserProducts() async -> Result<[ProductModel], UseCaseError>
}
protocol ProductListOrUnlistProtocol {
    func productListOrUnlist(_ unlistProductReq: UnlistProductReq) async -> Result<Bool, UseCaseError>
}

struct ProductUseCase: SearchProdByName, AddProd, GetAllProducts,GetUserProducts, ProductListOrUnlistProtocol{
    var repo: IProductRepository
    
    func productListOrUnlist(_ unlistProductReq: UnlistProductReq) async -> Result<Bool, UseCaseError> {
           do {
               let success = try await repo.productListOrUnlist(unlistProductReq)
               return .success(success)
           } catch let error as APIServiceError {
               switch error {
               case .statusNotOK(let message):
                   return .failure(.error(message: message))
               default:
                   return .failure(.networkError)
               }
           } catch {
               return .failure(.networkError)
           }
       }
   
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
    func getUserProducts() async -> Result<[ProductModel], UseCaseError> {
        do {
            let products = try await repo.getUserProducts()
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

}
    
