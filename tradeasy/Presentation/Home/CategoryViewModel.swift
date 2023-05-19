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
    
    func fetchCategories() async throws -> [CategoryModel] {
        DispatchQueue.main.async {
            self.state = .loading
        }
        do {
            let result = await getCategoryUseCase.fetchCategories()
            
            switch result {
            case .success(let categories):
                DispatchQueue.main.async {
                    self.state = .categorySuccess(categories)
                }
                return categories
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error)
                }
                throw error
            }
        } catch {
            DispatchQueue.main.async {
                self.state = .error(error)
            }
            throw error
        }
    }
}

