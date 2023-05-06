//
//  BidderRepositoryImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation
import Alamofire

struct BidderRepositoryImpl: IBidderRepository {
    
    let bidderApi: BidderAPI

        func fetchBids(forProduct productId: String) async throws -> [BidderModel] {
            try await bidderApi.fetchBids(forProduct: productId)
        }
}

