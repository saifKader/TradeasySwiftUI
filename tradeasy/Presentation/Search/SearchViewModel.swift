//
//  SearchViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//

import Foundation
enum ProductListState {
    case idle
    case loading
    case productSucess([ProductModel])
    case error(Error)
}



class SearchProductViewModel: ObservableObject {
    @Published var state: ProductListState = .idle // Add a published property to hold the current state
    var isLoading: Bool {
            if case .loading = state {
                return true
            }
            return false
        }
    var getProductUseCase : ProductUseCase

    init() {
        @Inject var repository: IProductRepository
        getProductUseCase = ProductUseCase(repo: repository)
    }



    
    func searchProduct(prodName: ProdNameReq, completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading // Set state to loading before starting the request
        }

        Task {
            let result = await getProductUseCase.searchProdByName(prodName)
    
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self.state = .productSucess(products) // Set state to success if the request is successful
                    completion(.success(products))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error) // Set state to error if an error occurs
                    completion(.failure(error))
                }
            }
        }
    }
}
