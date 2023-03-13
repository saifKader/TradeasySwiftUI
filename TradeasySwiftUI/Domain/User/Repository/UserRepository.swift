//
//  UserRepository.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

protocol UserRepository{
    
    func register(_registerReq:RegisterReq) async throws -> UserModel

    
}
