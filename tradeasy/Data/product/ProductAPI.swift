//
//  ProductAPI.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//

import Foundation
import Alamofire
struct ProductAPI {
    

    struct ProductResponse: Decodable {
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
    func addProduct(_ addProductReq: AddProductReq) async throws -> ProductModel {
        let url = "\(kbaseUrl)\(kAddProduct)"
        let userPreferences = UserPreferences()
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "jwt": (userPreferences.getUser()?.token)!
        ]

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<ProductModel, Error>) in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(addProductReq.name.utf8), withName: "name")
                multipartFormData.append(Data(addProductReq.description.utf8), withName: "description")
                multipartFormData.append(Data("\(addProductReq.price)".utf8), withName: "price")
                multipartFormData.append(Data(addProductReq.category.utf8), withName: "category")
                multipartFormData.append(Data("\(addProductReq.quantity)".utf8), withName: "quantity")
                multipartFormData.append(Data(addProductReq.bid_end_date.utf8), withName: "bid_end_date")
                multipartFormData.append(Data("\(addProductReq.forBid)".utf8), withName: "forBid")

                if let imageData = addProductReq.image.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "image", fileName: "product.jpg", mimeType: "image/jpeg")
                }
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers)
            .validate(statusCode: 200..<202)
            .responseJSON { response in
                switch response.result {
                case .success(let jsonData):
                    let productData = (jsonData as? [String: Any] ?? [:])["data"] as? [String: Any] ?? [:]
                    do {
                        let product = try JSONDecoder().decode(ProductModel.self, from: JSONSerialization.data(withJSONObject: productData))
                        continuation.resume(returning: product)
                    } catch {
                        continuation.resume(throwing: error)
                    }
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
    
    func getAllProducts() async throws -> [ProductModel] {
        let url = "\(kbaseUrl)\(kGetAllProducts)"
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get)
                .validate(statusCode: 200..<305)
                .responseDecodable(of: [ProductModel].self) { response in
                    switch response.result {
                    case .success(let products):
                        continuation.resume(returning: products)
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
    /*func addProdToSaved(_ product_id: String) async throws -> UserModel {
        let url = "\(kbaseUrl)\(kAddProdToSaved)"
        let userPreferences = UserPreferences()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "jwt": (userPreferences.getUser()?.token)!
        ]

        let parameters: [String: Any] = [
            "product_id": product_id
        ]

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<UserModel, Error>) in
            AF.request(url, method: .post, parameters: parameters, headers: headers)
                .validate(statusCode: 200..<202)
                .responseDecodable(of: UserModel.self) { response in
                    switch response.result {
                    case .success(let userResponse):
                        continuation.resume(returning: userResponse)
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
*/


}
