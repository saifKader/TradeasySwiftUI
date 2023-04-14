
 
import Foundation

class UserDataManager {
    private let userDataViewModel = GetUserDataStateViewModel()
    private let userPreferences = UserPreferences()

    func getUserDataAndUpdatePreferences(completion: @escaping (Result<UserModel, Error>) -> Void) {
        userDataViewModel.getUserData() { result in
            switch result {
            case .success(let userModel):
                DispatchQueue.main.async {
                    self.userPreferences.setUser(user: userModel)
                    completion(.success(userModel))
                }
            case .failure(let error):
                if case let UseCaseError.error(message) = error {
                    completion(.failure(UseCaseError.error(message: message)))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
