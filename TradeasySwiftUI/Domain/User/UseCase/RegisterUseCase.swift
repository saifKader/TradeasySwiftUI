enum UseCaseError: Error {
    case networkError, decodingError, error(message: String)
}

protocol Register {
    func execute(_registerReq: RegisterReq) async -> Result<UserModel, UseCaseError>
}

import Foundation

struct RegisterUseCase: Register {
    var repo: IAuthRepository
    
    func execute(_registerReq: RegisterReq) async -> Result<UserModel, UseCaseError> {
        do {
            let register = try await repo.register(_registerReq:_registerReq)
            return .success(register)
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
