enum UseCaseError: Error {
    case networkError, decodingError
}

protocol Register {
    func execute(_registerReq: RegisterReq) async -> Result<UserModel, UseCaseError>
}

import Foundation

struct RegisterUseCase: Register {
    var repo: UserRepository
    
    func execute(_registerReq: RegisterReq) async -> Result<UserModel, UseCaseError> {
        do {
            let register = try await repo.register(_registerReq:_registerReq)
            return .success(register)
        } catch(let error) {
            switch(error) {
            case APIServiceError.decodingError:
                return .failure(.decodingError)
            default:
                return .failure(.networkError)
            }
        }
    }
}
