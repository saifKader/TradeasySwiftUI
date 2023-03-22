//
//  UserRepositoryImpl.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 22/3/2023.
//

import Foundation

struct UserRepositoryImpl: IUserRepository{
    var dataSource: IUserRepository
    
    func forgetpassword(_forgetpasswordreq: ForgetPasswordReq){
        let _forgetpassword = try await dataSource.forgetpassword(_forgetpasswordreq: _forgetpasswordreq)
        return _forgetpassword
    }
    
}
