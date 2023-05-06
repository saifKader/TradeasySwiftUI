//
//  IBidderRepository.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation

protocol IBidderRepository {
    func fetchBids(forProduct productId: String) async throws -> [BidderModel]
    
}
