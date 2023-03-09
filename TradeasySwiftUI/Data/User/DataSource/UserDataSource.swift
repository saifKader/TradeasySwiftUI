//
//  UserDataSource.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation
import Combine

protocol UserDataSource {
    func register(_ registerReq: RegisterReq) -> AnyPublisher<BaseResult<UserModel, WrappedResponse<UserModel>>, Error>
}
