//
//  ResetPasswordView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject var viewModel = ForgetPasswordViewModel()
    @State private var password = ""
    @State private var confirmPassword = ""
    let email: String
    let otp : String
    @EnvironmentObject var navigationController: NavigationController
    @State private var showError = false
    @State private var errorMessage = ""

    var isFormValid: Bool {
        !password.isEmpty && !confirmPassword.isEmpty
    }

    var body: some View {
        VStack {
            SecureField("New password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
            SecureField("Confirm password", text: $confirmPassword)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))

            ActionButton(
                text: "Confirm",
                action: {
                    guard password == confirmPassword else {
                        errorMessage = "Passwords do not match"
                        showError = true
                        return
                    }
                    viewModel.resetPassword(email: email, otp: otp, password: password) { result in
                        switch result {
                        case .success:
                            viewModel.state = .success
                            navigationController.navigate(to: LoginView())
                        case .failure(let error):
                            if case let UseCaseError.error(message) = error {
                                errorMessage = message
                                showError = true
                                print("Error resetting password: \(message)")
                            } else {
                                print("Error resetting password: \(error)")
                            }
                        }
                    }
                },
                isFormValid: isFormValid,
                isLoading: viewModel.isLoading // P
            )
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage))
        }
    }
}
struct resetpasswordview: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(email: "", otp: "")
    }
}
