//
//  UserUseCase.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation

import SwiftUI

protocol ChatBot {
    func chatBot(_ message: ChatBotReq) async -> Result<String, UseCaseError>
}
struct ChatBotUseCase:ChatBot {

    
    
   
    var repo: IUserRepository


    func chatBot(_ message: ChatBotReq) async -> Result<String, UseCaseError> {
        do {
            let message = try await repo.chatBot(message)
            return .success(message)
        } catch(let error as APIServiceError) {
            switch(error) {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    
}
    
