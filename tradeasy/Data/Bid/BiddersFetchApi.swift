//
//  BiddersFetchApi.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation
import Alamofire

struct BidderAPI {
    
    struct BidsResponse: Decodable {
        let data: [BidderModel]
    }
    func fetchBids(forProduct productId: String) async throws -> [BidderModel] {
        var urlComponents = URLComponents(string: "\(kbaseUrl)\(kFetchBids)") // Replace kFetchBids with the correct API endpoint
        urlComponents?.queryItems = [URLQueryItem(name: "product_id", value: productId)]
        
        guard let url = urlComponents?.url else {
            fatalError("Invalid URL")
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: BidsResponse.self) { response in
                    switch response.result {
                    case .success(let bidsResponse):
                        print("dkhal")
                        print(bidsResponse.data)
                        for bidder in bidsResponse.data {
                            print(bidder.userName)
                                            }
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
