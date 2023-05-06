//
//  NotificationApi.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 6/5/2023.
//

import Foundation
import Alamofire

struct NotificationAPI {
    
    struct NotificationResponse: Decodable {
            let data: [NotificationModel]
        }
 
        
        func fetchNotifications() async throws -> [NotificationModel] {
            
            let userPreferences = UserPreferences()
            let url = "\(kbaseUrl)\(kFetchNotification)" 
               
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "jwt": (userPreferences.getUser()?.token)!
            ]
            
            
    
            
            return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[NotificationModel], Error>) in
                AF.request(url, method: .get, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: NotificationResponse.self) { response in
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

