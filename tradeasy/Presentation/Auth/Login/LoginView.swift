//
//  LoginView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import SwiftUI
import CoreData
import CountryPickerView
import GoogleSignIn
import FirebaseCore
import FirebaseAuth


struct LoginView: View {
    @ObservedObject var firebaseRegisterViewModel = FirebaseRegisterViewModel()
    @ObservedObject var viewModel = LoginViewModel()
    @State private var selectedCountry: Country?
    @State var username = ""
    @State var countryCode = ""
    @State var phoneNumber = ""
    @State var email = ""
    @State var password = ""
    @State var profilePicture = ""
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
                VStack {
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
                    TradeasyTextField(placeHolder: "Username", maxLength: 30,textValue: $username, keyboardType: .default)
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
                    SignInWithGoogleButton {
                        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                        // Create Google Sign In configuration object.
                        let config = GIDConfiguration(clientID: clientID)
                        GIDSignIn.sharedInstance.configuration = config

                        // Start the sign in flow!
                        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                            guard error == nil else {
                                // Handle error here
                                print("Error signing in: \(error!.localizedDescription)")
                                return
                            }

                            guard let user = result?.user,
                                let idToken = user.idToken?.tokenString
                            else {
                                // Handle error here
                                print("Failed to get user or idToken")
                                return
                            }
               
                            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                           accessToken: user.accessToken.tokenString)
                            Auth.auth().signIn(with: credential) { authResult, error in
                                    guard error == nil else {
                                        // Handle error here
                                        print("Error signing in to Firebase: \(error!.localizedDescription)")
                                        return
                                    }
                           
                                    var email = ""
                                    // Get the user's email address
                                if let photoURL = authResult?.user.photoURL {
                                       let profilePictureURLString = photoURL.absoluteString
                                       print("Profile picture URL: \(profilePictureURLString)")
                                       // You can use the URL string to display or manipulate the profile picture
                                       
                                       // Assign the profile picture URL string to your variable if needed
                                       profilePicture = profilePictureURLString
                                   }
                                if let userEmail = authResult?.user.email {
                                        print("User email: \(userEmail)")
                                    email = userEmail
                                 
                                    
                                    }
                             
                                var firebaseRegisterReq: FirebaseRegisterReq {
                                    return FirebaseRegisterReq(
                                        username: "", countryCode: "", phoneNumber: "", email: email, profilePicture: profilePicture
                                    )
                                }
                                firebaseRegisterViewModel.firebaseRegister(firebaseRegisterReq: firebaseRegisterReq){ result in
                                    switch result {
                                    case .success(let userModel):
                                        print("User logged in successfully: \(userModel)")
                                        DispatchQueue.main.async {
                                            print("user is \(userModel) ")
                                            userPreferences.setUser(user: userModel)
                                           
                                            navigationController.popToRoot()
                                        }
                                      
                                    case .failure(let error):
                                        if case let UseCaseError.error(message) = error {
                                            errorMessage = message
                                    
                                            print("Error logging in: \(message)")
                                            if message == "410" {
                                                navigationController.navigate(to: FirebaseRegisterView(email: email, profilePicture: $profilePicture))
                                                
                                            }
                                            if message == "408" {
                                          
                                                navigationController.navigate(to: MainView())
                                         
                                                
                                            }
                                        } else {
                                            print("Error logging in: \(error)")
                                        }
                                    }
                                }
                                }
                            // Sign in to Firebase with the Google credential
                        }

                    }
                    
                    VStack{
                        
                        Spacer()
                        Divider().padding(.horizontal, 0).padding(.top,0)
                        HStack {
                            Spacer()
                            
                            Text(LocalizedStringKey("New member?"))
                                .foregroundColor(Color("font_color"))
                            
                            
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
                        navigationController.currentTab = 0
                        navigationController.popToRoot()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("font_color"))
                    }
                )
                
            }
        }
    }
}




