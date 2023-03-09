//
//  TodoAPIImpl.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

enum APIServiceError: Error{
    case badUrl, requestError, decodingError, statusNotOK
}

struct UserAPIImpl: UserDataSource{
    
    
    func register() async throws -> [RegisterModel] {
        
        guard let url = URL(string:  "\(Constants.BASE_URL)/todos") else{
            throw APIServiceError.badUrl
        }
        
        guard let (data, response) = try? await URLSession.shared.data(from: url) else{
            throw APIServiceError.requestError
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIServiceError.statusNotOK
        }
        
        guard let result = try? JSONDecoder().decode([RegisterAPIEntity].self, from: data) else {
            throw APIServiceError.decodingError
        }
        
        return result.map({ item in
            RegisterModel(
                username: item.username,
                phoneNumber: item.phoneNumber,
                email: item.email,
                password: item.password
                
            )
        })
    }
}
