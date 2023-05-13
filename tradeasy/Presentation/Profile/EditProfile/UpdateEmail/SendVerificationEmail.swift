//
//  FPView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 20/3/2023.
//

import SwiftUI


struct SendVerificationEmail: View {
    @StateObject var viewModel = UpdateEmailViewModel()
    @State private var email = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @EnvironmentObject var navigationController: NavigationController
    
    @State private var showVerification = false
    @State private var isOTPVerificationEmail = false
    let userPreferences = UserPreferences()
    var isFormValid: Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let currentEmail = userPreferences.getUser()?.email ?? ""
        print("here \(trimmedEmail)")
        print("here2 \(currentEmail)")
        return !trimmedEmail.isEmpty && trimmedEmail != currentEmail
    }

    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email.trimmingCharacters(in: .whitespaces))
    }
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 10) {
                    Text("Update email")
                        .font(.title)
                    Text("We'll send you an OTP to verify your email. ")


                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    
                    TextField(LocalizedStringKey("Email"), text: $email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: email) { newValue in
                                print(isFormValid)
                            }
                    
                    
                    AuthButton(
                        text: "Send Email",
                        action: {
                            if(!isEmailValid){
                                errorMessage="invalid email"
                                showError = true
                                return
                            }
                            viewModel.sendVerificationEmail(email: email) { result in
                                switch result {
                                case .success(_):
                                    
                                    DispatchQueue.main.async {
                                        
                                        showVerification = true
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
                        },
                        isEnabled: isFormValid,
                        isLoading: viewModel.isLoading
                    )
                    Spacer(minLength: 0)
                }
            }
       
            .padding(.horizontal, 20)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color("background_color"))
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage))
            }
            .background(
              
                NavigationLink(
                    destination: OTPVerificationEmailView(email: email),
                    isActive: $showVerification,
                    label: { EmptyView() }
                )
            )
        }
    }
}
