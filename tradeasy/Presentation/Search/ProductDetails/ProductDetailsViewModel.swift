//
//  ProductDetailsViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 13/4/2023.
//

import Foundation

enum ProductDetailsViewState {
    case idle
    case loading
    case success(ProductModel)
    case error(Error)
}

enum SaveState {
    case idle
    case loading
    case success
    case error(Error)
}

class ProductDetailsViewModel: ObservableObject {
    @Published var state: ProductDetailsViewState = .idle
    @Published var saveState: SaveState = .idle
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    var isSaving: Bool {
        if case .loading = saveState {
            return true
        }
        return false
    }
    
    private let userUseCase: UserUseCase
    private let userPreferences = UserPreferences()
    
    init() {
        @Inject var userRepository: IUserRepository
        self.userUseCase = UserUseCase(repo: userRepository)
    }
    
    func isProductSaved(productID: String, user: UserModel) -> Bool {
        if let savedProducts = user.savedProducts {
            for savedProduct in savedProducts {
                if savedProduct._id == productID {
                    return true
                }
            }
        }
        return false
    }

    func saveProduct(productID: String) {
        DispatchQueue.main.async {
            self.saveState = .loading // Set save state to loading before starting the request
        }

        Task {
            do {
                let userModel = try await userUseCase.addToSavedItems(productID)
                print("it stopped here")
                let userModel2 = try await userUseCase.getCurrentUser()
                
                DispatchQueue.main.async {
                    self.userPreferences.setUser(user: userModel2)
                    self.saveState = .success // Set save state to success if the request is successful
                }
            } catch(let error) {
                DispatchQueue.main.async {
                    print("Error: \(error)") // Add a print statement to log the error
                    self.saveState = .error(error) // Set save state to error if an error occurs
                }
            }
        }
    }







}

