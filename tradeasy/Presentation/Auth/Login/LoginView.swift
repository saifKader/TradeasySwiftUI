//
//  LoginView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import SwiftUI
import CoreData
import CountryPickerView


struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    @State private var selectedCountry: Country?
    @State var username = ""
    @State var countryCode = ""
    @State var phoneNumber = ""
    @State var email = ""
    @State var password = ""
    @State private var isPasswordVisible = false
    @State private var errorMessage = ""
    @State var showError = false
    private func getStrokeBorder(isInvalid: Bool) -> some View {
        return RoundedRectangle(cornerRadius: 10)
            .strokeBorder(isInvalid ? Color.red : Color.gray, lineWidth: isInvalid ? 3 : 1)
    }
    
  



    var loginReq: LoginReq {
        return LoginReq(
            username: username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            password: password
        )
    }

    var isFormValid: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Login")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal, 5)
            .padding(.top, 150)

            TextField("Username", text: $username)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                .padding(.horizontal, 5)
                .padding(.top, 10)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: username) { newValue in
                        if newValue.count > 30 {
                            username = String(newValue.prefix(30))
                        }
                        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._0123456789")
                        let filteredValue = newValue.filter { allowedCharacterSet.contains(UnicodeScalar(String($0))!) }
                        if filteredValue != newValue {
                            username = filteredValue
                        }
                    }
                

            
        

              
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                       
                } else {
                    SecureField("Password", text: $password)
                }

                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.secondary)
                }
                    
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
            .padding(.horizontal, 5)
            .padding(.top, 5)
                    
      
            
            ActionButton(
                
                text: "LOGIN",
                action: {
                    Task {
                       
                        
                        viewModel.loginUser(loginReq: loginReq) { result in
                            switch result {
                            case .success(let userModel):
                                print("User logged in successfully: \(userModel)")
                                // TODO: Navigate to the next screen
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
                    }
                },
                isFormValid: isFormValid,
                isLoading: viewModel.isLoading // P
            )
        
     

                        // Display a loading indicator if the state is 'loading'
                      

                        // Display an error message if the state is 'error'
               

                        Spacer()
                    }
                    .padding()
                    .alert(isPresented: $showError) {
                                AlertHelper.showAlert(title: "Login", message: errorMessage)
                            }
    }
}




