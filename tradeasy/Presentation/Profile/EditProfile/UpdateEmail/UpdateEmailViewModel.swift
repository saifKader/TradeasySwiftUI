//
//  UpdateEmailViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation

enum UpdateEmailState: Equatable {
    case idle
    case loading
    case success
    case error(Error)

    static func == (lhs: UpdateEmailState, rhs: UpdateEmailState) -> Bool {
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


class UpdateEmailViewModel: ObservableObject {
    @Published var state: UpdateEmailState = .idle
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
    
    func sendVerificationEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        Task {
            let forgetPasswordReq = ForgetPasswordReq(email: email)
            let result = await userUseCase.sendEmailVerification(forgetPasswordReq)
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.state = .success
                    completion(.success(()))
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.state = .error(error) // Set state to error if an error occurs
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    func resendVerificationEmail(email: String, completion: @escaping (Error?) -> Void) {

        Task {
            let forgetPasswordReq = ForgetPasswordReq(email: email)
            let result = await userUseCase.sendEmailVerification(forgetPasswordReq)
        }
    }

    
    func changeEmail(otp: String, newEmail: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        Task {
            let changeEmailReq = ChangeEmailReq(otp: otp, newEmail: newEmail)
            let result = await userUseCase.changeEmail(changeEmailReq)
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.state = .success
                    completion(.success(()))
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
