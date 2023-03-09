//
//  RegisterViewModel.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var countryCode=""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    private let registerUseCase: Register
    
    init(registerUseCase: Register) {
        self.registerUseCase = registerUseCase
    }
    
    func registerUser() async throws -> UserModel {
        // Check if passwords match
        guard password == confirmPassword else {
            throw RegisterError.passwordsDoNotMatch
        }
        
        // Create a RegisterReq object with the user's input
        let registerReq = RegisterReq(
            username: username,
            countryCode: countryCode,
            phoneNumber: phoneNumber,
            email: email,
            password: password
        )
        
        // Call the register use case to register the user
        let result = await registerUseCase.execute(_registerReq: registerReq)
        
        switch result {
        case .success(let userModel):
            return userModel
        case .failure(let error):
            throw error
        }
    }
}

enum RegisterError: Error {
    case passwordsDoNotMatch
}

