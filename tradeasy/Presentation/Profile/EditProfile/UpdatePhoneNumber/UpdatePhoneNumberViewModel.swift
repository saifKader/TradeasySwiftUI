//
//  UpdateEmailViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation

enum UpdatePhoneNumberState: Equatable {
    case idle
    case loading
    case success(UserModel)
    case error(Error)

    static func == (lhs: UpdatePhoneNumberState, rhs: UpdatePhoneNumberState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}


class UpdatePhoneNumberViewModel: ObservableObject {
    @Published var state: UpdatePhoneNumberState = .idle
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
    

    
    func changePhoneNumber(req:ChangePhoneNumberReq, completion: @escaping (Result<UserModel, Error>) -> Void) {
       
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        Task {
           
            let result = await userUseCase.changePhoneNumber(req)
            DispatchQueue.main.async {
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
}
