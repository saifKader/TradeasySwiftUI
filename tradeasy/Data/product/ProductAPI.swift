//
//  ProductAPI.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//

import Foundation
import Alamofire
struct ProductAPI {
    

    struct ProductResponse: Codable {
        let data: [ProductModel]
    }


    func searchProductByname(_ productNameReq: ProdNameReq) async throws -> [ProductModel]  {
        let url = "\(kbaseUrl)\(ksearchProdByName)"
        let userPreferences = UserPreferences()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "jwt": (userPreferences.getUser()?.token)!
        ]

        let parameters: [String: Any] = [
            "name": productNameReq.name
        ]
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[ProductModel], Error>) in
            AF.request(url, method: .get, parameters: parameters, headers: headers)
                .validate(statusCode: 200..<202)
                .responseDecodable(of: ProductResponse.self) { response in
                    switch response.result {
                    case .success(let productResponse):
                        continuation.resume(returning: productResponse.data)
                    
                    case .failure(let error):
                        if let data = response.data {
                            do {
                                print("producssasata are \(data)")
                                throw errorFromResponseData(data)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        } else {
                            print("producsta assre ")
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
}
