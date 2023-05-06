//
//  ICategoryRepository.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation
protocol ICategoryRepository {
    func fetchCategories() async throws -> [CategoryModel]
    
}
