//
//  FPView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 20/3/2023.
//

import SwiftUI


struct ForgetPasswordView: View {
    @StateObject var viewModel = ForgetPasswordViewModel()
    @State private var email = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var showVerification = false // P
    
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 10) {
                    Text("Reset Password")
                                       .font(.largeTitle)
                    Text("Please enter your email to receive an OTP code to reset your password")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    
                    TextField(LocalizedStringKey("Email"), text: $email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    ActionButton(
                        text: "Reset Password",
                        action: {
                            viewModel.forgetPassword(email: email) { result in
                                switch result {
                                case .success:
                                    viewModel.state = .success
                                    showVerification = true
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
                        isFormValid: isFormValid,
                        isLoading: viewModel.isLoading // P
                    )
                    Spacer(minLength: 0)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage))
            }
            .background(
                NavigationLink(
                    destination: OTPVerificationView(email: email),
                    isActive: $showVerification,
                    label: { EmptyView() }
                )
            )
        }
    }
}

