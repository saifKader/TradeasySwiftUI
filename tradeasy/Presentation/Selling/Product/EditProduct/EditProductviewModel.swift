//
//  EditProductViewModel.swift
//  tradeasy
//
//  Created by Your Name on 16/4/2023.
//

import Foundation
import UIKit

enum EditProductState {
    case idle
    case loading
    case success(ProductModel)
    case error(Error)
}

class EditProductViewModel: ObservableObject {
    @Published var state: EditProductState = .idle // Add a published property to hold the current state
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var productUseCase: EditProduct
    
    init() {
        @Inject var repository: IProductRepository
        productUseCase = ProductUseCase(repo: repository)
    }
    func fetchCurrentImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let currentImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(currentImage)
                    }
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }

    func editProduct(editProductReq: EditProductReq, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading // Set state to loading before starting the request
        }

        Task {
            // Call the edit product use case to edit a product
            let result = await productUseCase.editProduct(editProductReq)

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
