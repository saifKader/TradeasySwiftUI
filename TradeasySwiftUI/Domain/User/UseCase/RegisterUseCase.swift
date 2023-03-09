enum UseCaseError: Error {
    case networkError, decodingError,email
}

protocol Register {
    func execute(_registerReq: RegisterReq) async -> AnyPublisher<BaseResult<UserModel, WrappedResponse<UserModel>>, Error>
}

import Foundation
import Combine

struct RegisterUseCase: Register {
    var repo: UserAPIImpl
    
    func execute(_registerReq: RegisterReq) async -> AnyPublisher<BaseResult<UserModel, WrappedResponse<UserModel>>, Error> {
        do {
            let register =   repo.register(_registerReq)
            return register
        }
        
    }
}
