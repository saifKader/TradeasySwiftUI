//
//  UserDefaults.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation
private let userDefaults = UserDefaults.standard

class UserPreferences: ObservableObject {
    @Published var user: UserModel?

    func setUser(user: UserModel) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)
            userDefaults.set(jsonString, forKey: "user")
        } catch {
            print(error.localizedDescription)
        }
    }

    func getUser() -> UserModel? {
        guard let jsonString = userDefaults.string(forKey: "user"),
              let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }

        do {
            let jsonDecoder = JSONDecoder()
            let user = try jsonDecoder.decode(UserModel.self, from: jsonData)
            return user
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func removeUser() {
        userDefaults.removeObject(forKey: "user")
    }
} 
/*class UserPreferences1: ObservableObject {
    @Published var user: UserModel?

    func setUser(user: UserModel) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)
            userDefaults.set(jsonString, forKey: "user_data")
            self.user = user
        } catch let error {
            print("Error saving user data: \(error)")
        }
    }

    func getUser() -> UserModel? {
        if let cachedUser = self.user {
            return cachedUser
        }

        guard let jsonString = userDefaults.string(forKey: "user_data") else {
            return nil
        }
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = jsonString.data(using: .utf8)!
            let user = try jsonDecoder.decode(UserModel.self, from: jsonData)
            self.user = user
            return user
        } catch let error {
            print("Error retrieving user data: \(error)")
            return nil
        }
    }

    func removeUser() {
        userDefaults.removeObject(forKey: "user_data")
        self.user = nil
    }
}*/


class ProductPreferences: ObservableObject {
    private let userDefaults = UserDefaults.standard
    @Published var products: [ProductModel]?
    
    init() {
        self.products = getProducts()
    }

    func setProduct(product: ProductModel) {
        var products = getProducts() ?? []

        if let _ = products.first(where: { $0._id == product._id }) {
            print("Product already exists.")
            return
        }

        if products.count >= 10 {
            products.removeFirst()
        }

        products.append(product)
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(products)
            let jsonString = String(data: jsonData, encoding: .utf8)
            userDefaults.set(jsonString, forKey: "product_data")
            self.products = products
        } catch let error {
            print("Error saving product data: \(error)")
        }
    }

    func getProducts() -> [ProductModel]? {
        guard let jsonString = userDefaults.string(forKey: "product_data") else {
            return nil
        }
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = jsonString.data(using: .utf8)!
            let products = try jsonDecoder.decode([ProductModel].self, from: jsonData)
            self.products = products
            return products
        } catch let error {
            print("Error retrieving product data: \(error)")
            return nil
        }
    }

    func removeProd() {
        userDefaults.removeObject(forKey: "product_data")
        self.products = nil
    }
}
