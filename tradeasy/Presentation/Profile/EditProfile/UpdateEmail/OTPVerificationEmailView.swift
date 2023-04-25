//
//  OTPVerificationEmailView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 6/4/2023.
//

import SwiftUI

struct OTPVerificationEmailView: View {
    
    enum isKeyBoardShowing: Hashable {
        case field
    }
    
    @StateObject var viewModel = UpdateEmailViewModel()
    @State private var otpText: String = ""
    @FocusState private var isKeyBoardShowing: isKeyBoardShowing?
    let email: String
    @State private var showError = false
    @State private var errorMessage = ""
    @EnvironmentObject var navigationController: NavigationController
    
    let userPreferences = UserPreferences()
    @Environment(\.presentationMode) var presentationMode
    var isFormValid: Bool {
        !otpText.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Verify OTP")
                .font(.largeTitle)
            Text("Enter the 6-digit OTP sent to your email \(userPreferences.getUser()?.email ?? "")")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(action: {
                viewModel.resendVerificationEmail(email: email) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                        showError = true
                    }
                }
            }) {
                Text("Resend?")
                    .foregroundColor(Color.blue)
            }
            
            HStack(spacing: 0) {
                ForEach(0..<6, id: \.self) { index in
                    OTPTextBox(index)
                }
            }
            .background(content: {
                TextField("", text: $otpText.limit(6))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .opacity(0.001)
                    .blendMode(.screen)
                    .focused($isKeyBoardShowing, equals: .field)
                    .onAppear {
                        self.isKeyBoardShowing = .field
                    }
                    .onChange(of: otpText) { newValue in
                        if newValue.count == 6 {
                            verifyOTP()
                        }
                    }
            })
            .contentShape(Rectangle())
            .padding(.bottom, 20)
            .padding(.top, 10)
            AuthButton(
                text: "Verify",
                action: {
                    verifyOTP()
                },
                isEnabled: isFormValid,
                isLoading: viewModel.isLoading
            )
            Spacer(minLength: 0)
                .disableWithOpacity(otpText.count < 6)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage))
        }
        .onChange(of: viewModel.state) { state in
            switch state {
            case .success:
                navigationController.isUpdateEmailPresent = false
                
            case .loading:
                break // Do nothing
            case .error(let error):
                if case let UseCaseError.error(message) = error {
                    errorMessage = message
                    showError = true
                } else {
                    print("Error changing email: \(error)")
                }
            case .idle:
                break // Do nothing
            }
        }
    }

    private func verifyOTP() {
        viewModel.changeEmail(otp: otpText, newEmail: email) { result in
            switch result {
            case .success(let userModel):
                print("User logged in successfully: \(userModel)")
                DispatchQueue.main.async {
                    userPreferences.setUser(user: userModel)
                }
                print("nik omake \(userModel)")
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
    }
   
    @ViewBuilder
    func OTPTextBox(_ index: Int)->some View{
        ZStack{
            if otpText.count > index {
                //char on index
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
                
            }else{
                Text("")
            }
        }
        .frame(width: 45,height: 45)
        .background{
            //highlighting current indexbox
            let status = ( otpText.count == index)
            RoundedRectangle(cornerRadius: 6,style: .continuous)
                .stroke(status ? Color("app_color") : .gray,lineWidth: 1)
        }
        .frame(maxWidth: .infinity)
    }
}
