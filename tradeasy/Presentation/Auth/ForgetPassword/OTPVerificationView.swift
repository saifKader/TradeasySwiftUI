//
//  VerifyOTPView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 23/3/2023.
//

// VerifyOTPView.swift
// tradeasy
// Created by abdelkader seif eddine on 23/3/2023.

import SwiftUI

struct OTPVerificationView: View {
    @StateObject var viewModel = ForgetPasswordViewModel()
    @State private var otp = Array(repeating: "", count: 6)
    @State private var activeIndex = 0
    let email: String
    @EnvironmentObject var navigationController: NavigationController
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var otpVerified = false
    
    var body: some View {
        VStack {
            Text("Enter the OTP")
                .font(.largeTitle)
                .padding(.bottom, 30)
            
            HStack(spacing: 16) {
                ForEach(0..<6) { index in
                    FocusedTextField(text: $otp[index], keyboardType: .numberPad, becomeFirstResponder: index == activeIndex, moveToNextField: {
                        if index < otp.count - 1 {
                            activeIndex = index + 1
                        } else {
                            verifyOTP()
                        }
                    }, moveToPreviousField: {
                        if index > 0 {
                            activeIndex = index - 1
                        }
                    })
                    .frame(width: 40, height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage))
        }
        .background(
            NavigationLink(
                destination: ResetPasswordView(email: email, otp: otp.joined()),
                isActive: $otpVerified,
                label: { EmptyView() }
            )
        )
    }
    
    private func verifyOTP() {
        let enteredOTP = otp.joined()
        
        viewModel.verifyOtp(email: email, otp: enteredOTP) { result in
            switch result {
            case .success:
                viewModel.state = .success
                otp = Array(repeating: "", count: 6)
                activeIndex = 0
                otpVerified = true
            case .failure(let error):
                if case let UseCaseError.error(message) = error {
                    errorMessage = message
                    showError = true
                } else {
                    print("Error verifying OTP: \(error)")
                }
            }
        }
    }
}

struct otpview: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(email: "")
    }
}
