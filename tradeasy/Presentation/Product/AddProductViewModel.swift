//
//  AddProductViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 12/4/2023.
//

import Foundation

enum AddProductState {
    case idle
    case loading
    case success(ProductModel)
    case error(Error)
}

class AddProductViewModel: ObservableObject {
    @Published var state: AddProductState = .idle // Add a published property to hold the current state
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var productUseCase: AddProd
    
    init() {
        @Inject var repository: IProductRepository
        productUseCase = ProductUseCase(repo: repository)
    }
    
    func addProduct(addProductReq: AddProductReq, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading // Set state to loading before starting the request
        }

        Task {
            // Call the add product use case to add a product
            let result = await productUseCase.addProduct(addProductReq)

            DispatchQueue.main.async {
                switch result {
                case .success(let productModel):
                    self.state = .success(productModel) // Set state to success if the request is successful
                    completion(.success(productModel))
                case .failure(let error):
                    self.state = .error(error) // Set state to error if an error occurs
                    completion(.failure(error))
                }
            }
        }
    }
}

