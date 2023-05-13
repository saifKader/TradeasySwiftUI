//
//  CategoryRespositoryImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation
import Alamofire

struct CategoryRepositoryImpl: ICategoryRepository {
    let categoryApi: CategoryAPI

        func fetchCategories()async throws -> [CategoryModel] {
            try await categoryApi.fetchCategories()
        }
}
