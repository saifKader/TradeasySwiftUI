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
        
        func fetchCategories() async throws -> [CategoryModel] {
            let url = "\(kbaseUrl)\(kFetchCategory)" // Replace kFetchBids with the correct API endpoint
            
            return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CategoryModel], Error>) in
                AF.request(url, method: .get)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: CategoryResponse.self) { response in
                        switch response.result {
                        case .success(let categoryResponse):
                            continuation.resume(returning: categoryResponse.data)
                            print("hereaaaa")
                            print(categoryResponse.data)
                            
                        case .failure(let error):
                            if let data = response.data {
                                do {
                                    print("here1")
                                    throw errorFromResponseData(data)
                                } catch {
                                    print("here2")
                                    continuation.resume(throwing: error)
                                }
                            } else {
                                print("here3")
                                continuation.resume(throwing: error)
                            }
                        }
                    }
            }
        }
}
