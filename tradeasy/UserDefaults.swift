//
//  UserDefaults.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation

class UserPreferences {
    private let userDefaults = UserDefaults.standard

    func setUser(user: UserModel) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)
            userDefaults.set(jsonString, forKey: "user_data")
        } catch let error {
            print("Error saving user data: \(error)")
        }
    }

    func getUser() -> UserModel? {
        guard let jsonString = userDefaults.string(forKey: "user_data") else {
            return nil
        }
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = jsonString.data(using: .utf8)!
            let user = try jsonDecoder.decode(UserModel.self, from: jsonData)
            return user
        } catch let error {
            print("Error retrieving user data: \(error)")
            return nil
        }
    }
    func removeUser() {
         userDefaults.removeObject(forKey: "user_data")
     }
    
    
}
