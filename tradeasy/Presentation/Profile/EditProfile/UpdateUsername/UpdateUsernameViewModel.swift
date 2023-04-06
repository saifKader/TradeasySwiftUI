//
//  ForgetPasswordViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation

enum UpdateUsernameState {
    case idle
    case loading
    case success(UserModel)
    case error(Error)
}

class UpdateUsernameViewModel: ObservableObject {
    @Published var state: UpdateUsernameState = .idle
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    private let userUseCase: UserUseCase
    
    init() {
        @Inject var userRepository: IUserRepository
        self.userUseCase = UserUseCase(repo: userRepository)
    }
    

    
    func updateUsername(username: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading // Set state to loading before starting the request
        }

        Task {
            let result = await userUseCase.execute(username: username)
            switch result {
            case .success(let userModel):
                DispatchQueue.main.async {
                    self.state = .success(userModel) // Set state to success if the request is successful
                    completion(.success(userModel))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error) // Set state to error if an error occurs
                    completion(.failure(error))
                }
            }
        }
    }
    
    
}
