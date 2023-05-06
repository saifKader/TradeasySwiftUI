// BidderUseCase.swift
// tradeasy
//
// Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation



protocol FetchBidsForProduct {
    func fetchBids(forProduct productId: String) async -> Result<[BidderModel], UseCaseError>
}
struct BidderUseCase: FetchBidsForProduct {
    var repo: IBidderRepository

    func fetchBids(forProduct productId: String) async -> Result<[BidderModel], UseCaseError> {
        do {
            let bids = try await repo.fetchBids(forProduct: productId)

            print("Fetched bids:")
            for bid in bids {
                print(bid.userName)
            }

            return .success(bids)
        } catch let error {
            if let apiError = error as? APIServiceError {
                switch apiError {
                case .statusNotOK(let message):
                    return .failure(.error(message: message))
                default:
                    return .failure(.networkError)
                }
            } else {
                // Handle other errors
                return .failure(.networkError)
            }
        }
    }
}
