import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var countryCode = ""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var mState: LoginActivityState = .initial
    
    private let registerUseCase: Register
     var cancellables = Set<AnyCancellable>()
    
    init(registerUseCase: Register) {
        self.registerUseCase = registerUseCase
    }
    
    func registerUser() {
        do {
            // Check if passwords match
            guard password == confirmPassword else {
                throw RegisterError.passwordsDoNotMatch
            }
            
            // Create a RegisterReq object with the user's input
            let registerReq = RegisterReq(
                username: username,
                countryCode: countryCode,
                phoneNumber: phoneNumber,
                email: email,
                password: password
            )
            
            setLoading()
            registerUseCase.execute(_registerReq: registerReq)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.hideLoading()
                        self.showToast(error.localizedDescription)
                    case .finished:
                        break
                    }
                } receiveValue: { baseResult in
                    self.hideLoading()
                    switch baseResult {
                    case .success(let data):
                        self.mState = .successLogin(data)
                    case .error(let wrappedResponse):
                        self.mState = .errorLogin(wrappedResponse)
                    }
                }
                .store(in: &cancellables)


                
                  
        } catch {
            showToast(error.localizedDescription)
        }
    }

    
    private func setLoading() {
        mState = .isLoading(true)
    }

    private func hideLoading() {
        mState = .isLoading(false)
    }

    private func showToast(_ message: String) {
        mState = .showToast(message)
    }
}

enum LoginActivityState {
    case initial
    case isLoading(Bool)
    case showToast(String)
    case successLogin(UserModel)
    case errorLogin(WrappedResponse<UserModel>)
}

enum RegisterError: Error {
    case passwordsDoNotMatch
}
