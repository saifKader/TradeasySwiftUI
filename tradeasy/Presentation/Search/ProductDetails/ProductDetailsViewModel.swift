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
enum ListUnlistState {
    case idle
    case loading
    case success
    case error(Error)

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}



class ProductDetailsViewModel: ObservableObject {
    @Published var state: ProductDetailsViewState = .idle
    @Published var saveState: SaveState = .idle
    @Published var listUnlistState: ListUnlistState = .idle
    @Published var isListingOrUnlisting: Bool = false
    @Published var isProductListed: Bool = false

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
    private let productUseCase: ProductUseCase
    private let userUseCase: UserUseCase
    private let userPreferences = UserPreferences()
    
    init() {
        @Inject var userRepository: IUserRepository
        self.userUseCase = UserUseCase(repo: userRepository)
        @Inject var productRepository: IProductRepository
        self.productUseCase = ProductUseCase(repo: productRepository)
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
    func productListOrUnlist(productID: String) {
        DispatchQueue.main.async {
            self.isListingOrUnlisting = true
        }

        Task {
            do {
                let unlistProductReq = UnlistProductReq(product_id: productID)
                let success = try await productUseCase.productListOrUnlist(unlistProductReq)
                let userModel = try await userUseCase.getCurrentUser()

                DispatchQueue.main.async {
                    self.userPreferences.setUser(user: userModel)
                    self.isProductListed.toggle()
                    self.isListingOrUnlisting = false
                }
            } catch(let error) {
                DispatchQueue.main.async {
                    print("Error: \(error)") // Add a print statement to log the error
                    self.listUnlistState = .error(error) // Set listUnlistState to error if an error occurs
                    self.isListingOrUnlisting = false
                }
            }
        }
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

