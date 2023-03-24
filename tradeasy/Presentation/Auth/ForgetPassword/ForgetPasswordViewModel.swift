//
//  ForgetPasswordViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation

enum ForgetPasswordState {
    case idle
    case loading
    case success
    case error(Error)
}

class ForgetPasswordViewModel: ObservableObject {
    @Published var state: ForgetPasswordState = .idle
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
    
    func forgetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        let forgetPasswordReq = ForgetPasswordReq(email: email)
        Task {
            let result = await userUseCase.execute(forgetPasswordReq)
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
    
    
    func verifyOtp(email: String, otp: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        let verifyOtpReq = VerifyOtpReq(email: email, otp: otp)
        Task {
            let result = await userUseCase.execute(verifyOtpReq)
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
    
    
    func resetPassword(email: String, otp: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        let resetPasswordReq = ResetPasswordReq(email: email, otp: otp, password: password)
        Task {
            let result = await userUseCase.execute(resetPasswordReq)
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
