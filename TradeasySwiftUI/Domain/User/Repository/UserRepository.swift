//
//  UserRepository.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

protocol IAuthRepository{
    
    func register(_registerReq:RegisterReq) async throws -> UserModel

    
}
