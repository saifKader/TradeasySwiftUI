//
//  BiddersFetchApi.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation
import Alamofire

struct CategoryAPI {
    
    struct CategoryResponse: Decodable {
            let data: [CategoryModel]
        }
        
        func fetchBids() async throws -> [CategoryModel] {
            let url = "\(kbaseUrl)\(kFetchCategory)" // Replace kFetchBids with the correct API endpoint
            
            return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CategoryModel], Error>) in
                AF.request(url, method: .get)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: CategoryResponse.self) { response in
                        switch response.result {
                        case .success(let bidsResponse):
                            continuation.resume(returning: bidsResponse.data)
                        case .failure(let error):
                            if let data = response.data {
                                do {
                                    throw errorFromResponseData(data)
                                } catch {
                                    continuation.resume(throwing: error)
                                }
                            } else {
                                continuation.resume(throwing: error)
                            }
                        }
                    }
            }
        }
}
