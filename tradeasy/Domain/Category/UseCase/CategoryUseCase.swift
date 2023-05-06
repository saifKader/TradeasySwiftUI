// BidderUseCase.swift
// tradeasy
//
// Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation



protocol ICategory {
    func fetchCategories() async -> Result<[CategoryModel], UseCaseError>
}
struct CategoryUseCase:  ICategory {
    
    
    var repo: ICategoryRepository

    func fetchCategories() async -> Result<[CategoryModel], UseCaseError> {
        do {
            let bids = try await repo.fetchCategories()
            return .success(bids)
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
}
