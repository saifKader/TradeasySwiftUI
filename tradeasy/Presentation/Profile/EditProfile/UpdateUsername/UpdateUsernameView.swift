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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = UpdateUsernameViewModel()
        let userPreferences = UserPreferences()
        @State var username = ""
    
    func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z0-9_]+$"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
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
                   
                    if(!isValidUsername(username)){
                        errorMessage = "Username containing only letters, numbers, and underscores."
                        showError = true

                        return
                    }
                    print("here")
                    viewModel.updateUsername(username: username) { result in
                        switch result {
                        case .success(let userModel):
                            print("User logged in successfully: \(userModel)")
                            DispatchQueue.main.async {
                                userPreferences.setUser(user: userModel)
                            }
                            print("zok omek \(userModel)")
                            self.presentationMode.wrappedValue.dismiss()
                            
                          
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
