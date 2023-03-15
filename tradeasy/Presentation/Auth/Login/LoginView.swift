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
  
            VStack(alignment: .leading) {
                
                HStack{
                    Spacer()
                    Image("app_logo_48")
                        .resizable()
                    
                        .frame(width: 130, height: 130)
                        .padding(.top,150)
                Spacer()
                }
                    Text(LocalizedStringKey("Login"))
                        .font(.title)
                        .fontWeight(.medium)
                
                    
                    
                        .padding(.horizontal, 5)
                        .padding(.top, 20)
               
                TextField(LocalizedStringKey("Username"), text: $username)
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
                        TextField(LocalizedStringKey("Password"), text: $password)
                        
                    } else {
                        SecureField(LocalizedStringKey("Password"), text: $password)
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
                .padding(.top, 10)
                
                
                
                ActionButton(
                    
                    text: "Login",
                    action: {
                        Task {
                            
                            
                            viewModel.loginUser(loginReq: loginReq) { result in
                                switch result {
                                case .success(let userModel):
                                    print("User logged in successfully: \(userModel)")
                                    let coreDataManager = CoreDataManager(context: viewContext)
                                               coreDataManager.saveUserToCoreData(userModel: userModel)
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
                ActionButton(
                    
                    text: "Login",
                    action: {
                        Task {
                            
                            let coreDataManager = CoreDataManager(context: viewContext)
                            
                         
                            print("AAAAAA")
                            print(coreDataManager.fetchAllUsers())
                         
                        }
                    },
                    isFormValid: isFormValid,
                    isLoading: viewModel.isLoading // P
                )
                
                VStack{
                    
                    Spacer()
                    Divider().padding(.horizontal, 0).padding(.top,0)
                    HStack {
                        Spacer()
                        
                        Text(LocalizedStringKey("New member?"))
                            .foregroundColor(.black)
                        
                        
                        Button(action: {
                            navigationController.navigate(to: RegisterView())
                            
                        }) {
                            Text(LocalizedStringKey("Join us"))
                                .foregroundColor(Color(CustomColors.blueColor))
                        }
                        .background(Color.clear)
                        
                        
                        
                        
                        Spacer()
                    }
                }
                
                // Display a loading indicator if the state is 'loading'
                
                
                // Display an error message if the state is 'error'
                
            }
            .padding()
            .alert(isPresented: $showError) {
                AlertHelper.showAlert(title: "Login", message: errorMessage)
            } .navigationBarBackButtonHidden(true) 
        }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}




