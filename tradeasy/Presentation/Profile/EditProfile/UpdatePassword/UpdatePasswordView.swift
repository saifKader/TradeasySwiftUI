//
//  UpdateUsernameView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 4/4/2023.
//

import Foundation
import SwiftUI
struct UpdatePasswordView: View {
    @State private var alerMessage = ""
    @State private var alerTitle = ""
    @EnvironmentObject var navigationController: NavigationController
    
    @ObservedObject var viewModel = UpdatePasswordViewModel()
        let userPreferences = UserPreferences()
    @State private var currentPassword: String = ""
      @State private var newPassword: String = ""
      @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false

        
        var body: some View {
            VStack {
                EditProfileTextField(text: "", onTextChanged: { newText in
                
                    currentPassword = newText
                           }, labelText: "Current password",secureInput: true)
                 ;
                 EditProfileTextField(text: "", onTextChanged: { newText in
                     newPassword = newText
                           }, labelText: "New password",secureInput: true)
                 ;
                 EditProfileTextField(text: "", onTextChanged: { newText in
                     confirmPassword = newText
               
                 }, labelText: "Confirm password",secureInput: true)
                 ;
            
                AuthButton(text: "update password", action: {
                              updatePassword()
                          }, isEnabled: isButtonEnabled, isLoading: false).alert(isPresented: $showAlert) {
                              AlertHelper.showAlert(title: alerTitle, message: alerMessage)
                          }

                          Spacer()
                      }
                  }

                  var passwordsMatch: Bool {
                      return newPassword == confirmPassword
                  }

                  var isButtonEnabled: Bool {
                      return !currentPassword.isEmpty && !newPassword.isEmpty && !confirmPassword.isEmpty
                  }

                  var validatePassword: Bool {
                      return newPassword.count >= 8
                  }

                  private func updatePassword() {
                      guard passwordsMatch else {
                          alerMessage = "Passwords do not match"
                          alerTitle = "error"
                          showAlert = true
                          alerTitle = "error"
                          return
                      }

                      guard validatePassword else {
                          alerMessage = "Password must be at least 8 characters"
                          alerTitle = "error"
                          showAlert = true
                          return
                      }

                      viewModel.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { result in
                          switch result {
                          case .success(let userModel):
                        
                              showAlert = true
                              alerTitle = "success"
                              DispatchQueue.main.async {
                                  userPreferences.setUser(user: userModel)
                                  print(userModel)
                                  print(userPreferences.getUser() == nil)
                                
                                  
                              }
                       

                          case .failure(let error):
                              if case let UseCaseError.error(message) = error {
                                  alerMessage = message
                                  alerTitle = "error"
                                  showAlert = true
                              } else {
                                  print("Error: \(error)")
                              }
                          }
                      }
                  }
              }
