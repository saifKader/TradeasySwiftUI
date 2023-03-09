//
//  UserAPIImpl.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation
import Combine

enum APIServiceError: Error{
    case badUrl, requestError, decodingError, statusNotOK,emailAlreadyExist
}

struct UserAPIImpl: UserDataSource {

    
    
    let baseUrl: String = "http://192.168.0.25:9090/user"
    
    func register(_ registerReq: RegisterReq) -> AnyPublisher<BaseResult<UserModel, WrappedResponse<UserModel>>, Error> {
        return Future { promise in
            let url = URL(string: "your_api_endpoint_here")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(registerReq)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    promise(.failure(error!))
                    return
                }
                
                if (200..<300).contains(httpResponse.statusCode), let data = data {
                    do {
                        let body = try JSONDecoder().decode(UserModel.self, from: data)
                        let registerEntity = "" as! UserModel
                        promise(.success(.baseSuccess(data: registerEntity)))
                    } catch {
                        promise(.failure(error))
                    }
                } else if let data = data {
                    do {
                        var  err = try JSONDecoder().decode(WrappedResponse<UserModel>.self, from: data)
                        err.code = httpResponse.statusCode
                        promise(.success(.error(rawResponse: err)))
                    } catch {
                        promise(.failure(error))
                    }
                } else {
                    do {
                        var  err = try JSONDecoder().decode(WrappedResponse<UserModel>.self, from: data!)
                        err.code = httpResponse.statusCode
                        promise(.success(.error(rawResponse: err)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            
            task.resume()
        }
        .eraseToAnyPublisher()
    }
}
    
