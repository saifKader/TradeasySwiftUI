//
//  ForgetPasswordViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import Foundation

enum SendVerificationSms: Equatable {
    case idle
    case loading
    case success
    case error(Error)

    static func == (lhs: SendVerificationSms, rhs: SendVerificationSms) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.success, .success):
            return true
        case let (.error(error1), .error(error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}


enum VerifyAccountOtp {
    case idle
    case loading
    case success(UserModel)
    case error(Error)
}

class SendVerificationSmsViewModel: ObservableObject {
    @Published var state: SendVerificationSms = .idle
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    @Published var otpState:VerifyAccountOtp = .idle
    var otpIsLoading: Bool{
        if case .loading = otpState {
            return true
        }
        return false
    }
    
    private let userUseCase: UserUseCase
    
    init() {
        @Inject var userRepository: IUserRepository
        self.userUseCase = UserUseCase(repo: userRepository)
    }
    

    
    func sendVerificationSms( completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            self.state = .loading // Set state to loading before starting the request
        }

        Task {
            let result = await userUseCase.sendVerificationSms()
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.state = .success
                    completion(.success(()))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error) // Set state to error if an error occurs
                    completion(.failure(error))
                }
            }
        }
    }
    func verifyAccount(otp: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        DispatchQueue.main.async {
            self.otpState = .loading // Set state to loading before starting the request
        }

        Task {
            let result = await userUseCase.verifyAccountOTP(otp: otp)
            switch result {
            case .success(let userModel):
                DispatchQueue.main.async {
                    self.otpState = .success(userModel) // Set state to success if the request is successful
                    completion(.success(userModel))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.otpState = .error(error) // Set state to error if an error occurs
                    completion(.failure(error))
                }
            }
        }
    }
    
}
