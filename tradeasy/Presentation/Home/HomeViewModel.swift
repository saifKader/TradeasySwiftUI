//
//  HomeViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 13/4/2023.
//

import Foundation

enum ProductHomeListState {
    case idle
    case loading
    case productSuccess([ProductModel])
    case error(Error)
}

class HomeViewModel: ObservableObject {
    
    @Published var state: ProductHomeListState = .idle
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var getProductUseCase: ProductUseCase
    
    init() {
        @Inject var repository: IProductRepository
        getProductUseCase = ProductUseCase(repo: repository)
    }
    var products: [ProductModel] {
           if case let .productSuccess(products) = state {
               return products
           }
           return []
       }
    
    func loadProducts() {
           state = .loading
           Task {
               print("Before calling getAllProducts") // Add this print statement
                       let result = await getProductUseCase.getAllProducts()
                       print("After calling getAllProducts") // Add this print statement
               DispatchQueue.main.async { [weak self] in
                   switch result {
                   case .success(let products):
                       print("Product success: \(products)") // Add this print statement
                       self?.state = .productSuccess(products)
                   case .failure(let error):
                       self?.state = .error(error)
                       print("Product error: \(error.localizedDescription)") // Add this print statement
                   }
               }
           }
       }
   }

