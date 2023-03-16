//
//  RegisterViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation
enum RegisterState {
    case idle
    case loading
    case success(UserModel)
    case error(Error)
}

class RegisterViewModel: ObservableObject {
    @Published var state: RegisterState = .idle // Add a published property to hold the current state
    var isLoading: Bool {
            if case .loading = state {
                return true
            }
            return false
        }
    var getRegisterUseCase: RegisterUseCase

    init() {
        @Inject var repository: IAuthRepository
        getRegisterUseCase = RegisterUseCase(repo: repository)
    }

    func registerUser(registerReq: RegisterReq, completion: @escaping (Result<UserModel, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading // Set state to loading before starting the request
        }

        Task {
            // Call the register use case to register the user
            let result = await getRegisterUseCase.execute(_registerReq: registerReq)

            DispatchQueue.main.async {
                switch result {
                case .success(let userModel):
                    self.state = .success(userModel) // Set state to success if the request is successful
                    completion(.success(userModel))
                case .failure(let error):
                    self.state = .error(error) // Set state to error if an error occurs
                    completion(.failure(error))
                }
            }
        }
    }
}


