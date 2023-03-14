//
//  RegisterViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation

class RegisterViewModel: ObservableObject {
   
    var getRegisterUseCase : RegisterUseCase
    init(){
            @Inject var repository: IAuthRepository
            
            getRegisterUseCase = RegisterUseCase(repo: repository)
        }
    
    
    
    func registerUser(registerReq:RegisterReq) async throws -> UserModel {
        // Check if passwords match
        
        
        // Create a RegisterReq object with the user's input
        
   
        // Call the register use case to register the user
        let result = await getRegisterUseCase.execute(_registerReq: registerReq)

        switch result {
        case .success(let userModel):
            return userModel
        case .failure(let error):
            throw error
        }
    }
}


