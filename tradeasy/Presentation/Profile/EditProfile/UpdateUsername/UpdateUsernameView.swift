//
//  UpdateUsernameView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 4/4/2023.
//

import Foundation
import SwiftUI
struct UpdateUsernameView: View {
    @State private var errorMessage = ""
    @EnvironmentObject var navigationController: NavigationController
    @State var showError = false
    
    @ObservedObject var viewModel = UpdateUsernameViewModel()
        let userPreferences = UserPreferences()
        @State var username = ""
    init() {
           if let initialUsername = userPreferences.getUser()?.username {
               _username = State(initialValue: initialUsername)
           }
       }
        
        var body: some View {
            VStack {
                EditProfileTextField(text: username) { newText in
                    username = newText
                }
                AuthButton(text: "update username", action: {
                    viewModel.updateUsername(username: username) { result in
                        switch result {
                        case .success(let userModel):
                            print("User logged in successfully: \(userModel)")
                            DispatchQueue.main.async {
                                userPreferences.setUser(user: userModel)
                                print(userPreferences.getUser() == nil)
                                navigationController.popToRoot()
                            }
                          
                        case .failure(let error):
                            if case let UseCaseError.error(message) = error {
                                errorMessage = message
                                showError = true
                                print("Error logging in: \(message)")
                            } else {
                                print("Error logging in: \(error)")
                            }
                        }
                    }
                    
                    
                    // Handle updating the username
                }, isEnabled: isFormValid, isLoading: false).alert(isPresented: $showError) {
                    AlertHelper.showAlert(title: "Error updating", message: errorMessage)
                }
                Spacer()
            }
        }

        var isFormValid: Bool {
            let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
            return !trimmedUsername.isEmpty && (userPreferences.getUser()?.username != trimmedUsername)
        }
    


   

}
