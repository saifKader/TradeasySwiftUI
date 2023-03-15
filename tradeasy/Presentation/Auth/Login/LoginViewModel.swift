//
//  LoginViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation

// Add an enum to represent the different states
enum LoginState {
    case idle
    case loading
    case success(UserModel)
    case error(Error)
}



class LoginViewModel: ObservableObject {
    @Published var state: LoginState = .idle // Add a published property to hold the current state
    var isLoading: Bool {
            if case .loading = state {
                return true
            }
            return false
        }
    var getLoginUseCase: LoginUseCase

    init() {
        @Inject var repository: IAuthRepository
        getLoginUseCase = LoginUseCase(repo: repository)
    }

    func loginUser(loginReq: LoginReq, completion: @escaping (Result<UserModel, Error>) -> Void) {
        state = .loading // Set state to loading before starting the request

        Task {
            let result = await getLoginUseCase.execute(_loginReq: loginReq)
            switch result {
            case .success(let userModel):
                state = .success(userModel) // Set state to success if the request is successful
                completion(.success(userModel))
            case .failure(let error):
                state = .error(error) // Set state to error if an error occurs
                completion(.failure(error))
            }
        }
    }
}
