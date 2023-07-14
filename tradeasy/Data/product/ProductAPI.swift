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

    func addRatingToProduct(_ addRatingReq: AddRatingReq) async throws -> ProductModel {
        let url = "\(kbaseUrl)\(kAddRatingToProduct)"
        let userPreferences = UserPreferences()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "jwt": (userPreferences.getUser()?.token)!
        ]

        let parameters: [String: Any] = [
            "product_id": addRatingReq.productId,
            "rating": addRatingReq.rating
        ]

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<ProductModel, Error>) in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ProductModel.self) { response in
                    switch response.result {
                    case .success(let productModel):
                        continuation.resume(returning: productModel)
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


    func searchProductByname(_ productNameReq: ProdNameReq) async throws -> [ProductModel]  {
        let url = "\(kbaseUrl)\(ksearchProdByName)"
        let userPreferences = UserPreferences()
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let token = userPreferences.getUser()?.token {
            headers["jwt"] = token
        }
        
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

    
    func getAllProducts() async throws -> [ProductModel] {
        let url = "\(kbaseUrl)\(kGetAllProducts)"
        let userPreferences = UserPreferences()
        
        var headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        if let token = userPreferences.getUser()?.token {
            headers["jwt"] = token
            
        }
        

        if headers["jwt"] == nil {
            headers.remove(name: "jwt")
        }

        
       
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, headers: headers)
                .validate(statusCode: 200..<305)
                .responseDecodable(of: [ProductModel].self) { response in
                    switch response.result {
                    case .success(let products):
                        print(products)
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


    func getUserProducts() async throws -> [ProductModel] {
        let url = "\(kbaseUrl)\(kGetUserProducts)"
        let userPreferences = UserPreferences()
        print("aaaa")
        print(userPreferences.getUser()?.token)
        var headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        if let token = userPreferences.getUser()?.token {
            headers["jwt"] = token
        }
        

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, headers: headers)
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

    func ProductListOrUnlist(_ unlistProductReq: UnlistProductReq) async throws -> Bool {
        let url = "\(kbaseUrl)\(kUnlistProduct)" // Replace kUnlistProduct with the correct endpoint
        let userPreferences = UserPreferences()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "jwt": (userPreferences.getUser()?.token)!
        ]

        let parameters: [String: Any] = [
            "product_id": unlistProductReq.product_id
        ]

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        continuation.resume(returning: true)
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
    func editProduct(_ editProductReq: EditProductReq) async throws -> ProductModel {
        let url = "\(kbaseUrl)\(kEditProduct)"
        let userPreferences = UserPreferences()
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "jwt": (userPreferences.getUser()?.token)!
        ]

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<ProductModel, Error>) in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data("\(editProductReq.prod_id)".utf8), withName: "prod_id")
                multipartFormData.append(Data(editProductReq.name.utf8), withName: "name")
                multipartFormData.append(Data(editProductReq.description.utf8), withName: "description")
                multipartFormData.append(Data("\(editProductReq.price)".utf8), withName: "price")
                multipartFormData.append(Data(editProductReq.category.utf8), withName: "category")
                multipartFormData.append(Data("\(editProductReq.quantity)".utf8), withName: "quantity")
                multipartFormData.append(Data(editProductReq.bid_end_date.utf8), withName: "bid_end_date")
                multipartFormData.append(Data("\(editProductReq.forBid)".utf8), withName: "forBid")

                if let imageData = editProductReq.image.jpegData(compressionQuality: 0.5) {
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


}




