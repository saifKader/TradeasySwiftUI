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
    
    enum isKeyBoardShowing: Hashable {
        case field
    }
    
    @StateObject var viewModel = ForgetPasswordViewModel()
    @State private var otpText: String = ""
    @FocusState private var isKeyBoardShowing: isKeyBoardShowing?
    let email: String
    @State private var showError = false
    @State private var errorMessage = ""
    @EnvironmentObject var navigationController: NavigationController
    @State private var otpVerified = false
    
    var isFormValid: Bool {
        !otpText.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Verify OTP")
                .font(.largeTitle)
            Text("Enter the 6-digit OTP sent to your email")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
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
            ActionButton(
                text: "Verify",
                action: {
                    verifyOTP()
                },
                isFormValid: isFormValid,
                isLoading: viewModel.isLoading // P
            )
            Spacer(minLength: 0)
                .disableWithOpacity(otpText.count < 6)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage))
        }
        .background(
            NavigationLink(
                destination: ResetPasswordView(email: email, otp: otpText),
                isActive: $otpVerified,
                label: { EmptyView() }
            )
        )
    }
    private func verifyOTP() {
        viewModel.verifyOtp(email: email, otp: otpText) { result in
            switch result {
            case .success:
                viewModel.state = .success
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
                Text(" ")
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
struct otpview: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(email: "")
    }
}

extension View{
    func disableWithOpacity(_ condition:Bool)->some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
}

//binding string extension
extension Binding where Value == String{
    func limit(_ length: Int)-> Self{
        if self.wrappedValue.count > length{
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
