//
//  HomeViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 13/4/2023.
//

import Foundation


enum CategoryHomeListState {
    case idle
    case loading
    case categorySuccess([CategoryModel])
    case error(Error)
}

class CategoryViewModel: ObservableObject {
    
    @Published var state: CategoryHomeListState = .idle
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var getCategoryUseCase: CategoryUseCase
    
    init() {
        @Inject var repository: ICategoryRepository
        getCategoryUseCase = CategoryUseCase(repo: repository)
    }
    var category: [CategoryModel] {
           if case let .categorySuccess(category) = state {
               return category
           }
           return []
       }
    
    func fetchCategories() {
           state = .loading
           Task {
               print("Before calling getAllProducts") // Add this print statement
                       let result = await getCategoryUseCase.fetchCategories()
                       print("After calling getAllProducts") // Add this print statement
               DispatchQueue.main.async { [weak self] in
                   switch result {
                   case .success(let categories):
                       print("Product success: \(categories)") // Add this print statement
                       self?.state = .categorySuccess(categories)
                   case .failure(let error):
                       self?.state = .error(error)
                       print("Product error: \(error.localizedDescription)") // Add this print statement
                   }
               }
           }
       }
   }
