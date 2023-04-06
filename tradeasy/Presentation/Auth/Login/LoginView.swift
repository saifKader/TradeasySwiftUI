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
    @EnvironmentObject var navigationController: NavigationController
    @State var showSheet: Bool = false
    @State var navigateToForgotPassword: Bool = false
    
    let userPreferences = UserPreferences()
    @Environment(\.managedObjectContext) private var viewContext
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
        NavigationView{
            ZStack{
                VStack() {
                    HStack{
                        Spacer()
                        Image("app_logo_48")
                            .resizable()
                        
                            .frame(width: 130, height: 130)
                            
                        Spacer()
                    }
                    Text(LocalizedStringKey("Tradeasy"))
                        .font(.title)
                        .fontWeight(.medium)
                    
                        .padding(.horizontal, 5)
                        .padding(.top, 20)
                    
                    TextField(LocalizedStringKey("Username"), text: $username)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
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
                            TextField(LocalizedStringKey("Password"), text: $password)
                                .background(Color.clear)
                        } else {
                            SecureField(LocalizedStringKey("Password"), text: $password)
                                .background(Color.clear)
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
                    .padding(.top, 10)
                    HStack{
                        Spacer()
                        NavigationLink(
                            destination: ForgetPasswordView(),
                            isActive: $navigateToForgotPassword,
                            label: {
                                Text("Forgot password?")
                                    .foregroundColor(Color(CustomColors.blueColor))
                                    .fontWeight(.medium)
                            })
                    }
                    
                    AuthButton(
                        text: "Login",
                        action: {
                            Task {
                                viewModel.loginUser(loginReq: loginReq) { result in
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
                            }
                        },
                        isEnabled: isFormValid,
                        isLoading: viewModel.isLoading
                    ).alert(isPresented: $showError) {
                        AlertHelper.showAlert(title: "Login", message: errorMessage)
                    }
                    VStack{
                        
                        Spacer()
                        Divider().padding(.horizontal, 0).padding(.top,0)
                        HStack {
                            Spacer()
                            
                            Text(LocalizedStringKey("New member?"))
                                .foregroundColor(Color("black_white"))
                            
                            
                            Button(action: {
                                showSheet = true
                            }) {
                                Text(LocalizedStringKey("Join us"))
                                    .foregroundColor(Color(CustomColors.blueColor))
                            }
                            .background(Color.clear)
                            .sheet(isPresented: $showSheet) {
                                RegisterView()
                            }
                            Spacer()
                        }
                    }
                }
                .padding()
                .navigationBarItems(
                    leading: Button(action: {
                        navigationController.popToRoot()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("black_white"))
                    }
                )
            }
        }
    }
}




