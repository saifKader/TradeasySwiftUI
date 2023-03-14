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
    var getRegisterUseCase : RegisterUseCase
    init(){
            @Inject var repository: IAuthRepository
            
            getRegisterUseCase = RegisterUseCase(repo: repository)
        }
    
    
    
    func registerUser() async throws -> UserModel {
        // Check if passwords match
        
        
        // Create a RegisterReq object with the user's input
        let registerReq = RegisterReq(
            username: username,
            countryCode: countryCode,
            phoneNumber: phoneNumber,
            email: email,
            password: password
        )
        print("1")
        // Call the register use case to register the user
        let result = await getRegisterUseCase.execute(_registerReq: registerReq)
        print("2")
        switch result {
        case .success(let userModel):
            return userModel
        case .failure(let error):
            throw error
        }
    }
}

