enum UseCaseError: Error{
    case networkError, decodingError
}

protocol GetTodos {
    func execute() async -> Result<[RegisterModel], UseCaseError>
}

import Foundation


struct RegisterUseCase: GetTodos{
    var repo: UserRepository
    
    func execute() async -> Result<[RegisterModel], UseCaseError>{
        do{
            let register = try await repo.register()
            return .success(register)
        }catch(let error){
            switch(error){
            case APIServiceError.decodingError:
                return .failure(.decodingError)
            default:
                return .failure(.networkError)
            }
        }
    }
}
