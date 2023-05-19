//
//  FPView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 20/3/2023.
//

import SwiftUI
import CountryPickerView

struct UpdatePhoneNumberView: View {
    @StateObject var smsViewModel = SendVerificationSmsViewModel()
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var selectedCountry: Country?
    @EnvironmentObject var navigationController: NavigationController
    @State var countryCode = ""
    @State private var showVerification = false
    @State private var isOTPVerificationPhoneNumber = false
    @State private var rawPhoneNumber = ""

    var phoneNumber: String {
        return countryCode + rawPhoneNumber
    }
    let userPreferences = UserPreferences()
    var isFormValid: Bool {
        let trimmedPhoneNumber = phoneNumber.trimmingCharacters(in: .whitespaces)
        let currentPhoneNumber = userPreferences.getUser()?.phoneNumber ?? ""
        print("here \(trimmedPhoneNumber)")
        print("here2 \(currentPhoneNumber)")
      //  && trimmedPhoneNumber != currentPhoneNumber
        return !trimmedPhoneNumber.isEmpty
    }


    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 10) {
                    Text("Update Phone number")
                        .font(.title)
                    Text("We'll send you an OTP to verify your phone number update request. ")


                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    HStack{
                        
                        CountryPickerViewWrapper(selectedCountry: $selectedCountry)
                            .frame(width: 50, height: 44)
                            .padding()
                            .onAppear {
                                              let pickerView = CountryPickerView()
                                              if let code = Locale.current.regionCode, let defaultCountry = pickerView.getCountryByCode(code) {
                                                  countryCode = defaultCountry.phoneCode
                                              }
                                          }
                            .onChange(of: selectedCountry) { country in
                                // update the view model's countryCode property when the selected country changes
                                countryCode = country!.phoneCode
                            }
                        TextField(LocalizedStringKey("Phone Number"), text: $rawPhoneNumber)
                            .padding()
                            .keyboardType(.numberPad)
                            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .onChange(of: rawPhoneNumber) { newValue in
                                        print(phoneNumber)
                                    }
                    }
                   
                    
                    
                    AuthButton(
                        text: "Send OTP",
                        action: {
                            if(!isFormValid){
                              print("aaaa \(countryCode)")
                                errorMessage="invalid phoneNumber"
                                showError = true
                                return
                            }
                            if(isValidPhoneNumber(phoneNumber)) {
                                return
                            }
                            smsViewModel.sendVerificationSms() { result in
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
                        isLoading: smsViewModel.isLoading
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
                    destination: OTPVerificationPhoneNumberView(phoneNumber: phoneNumber,countryCode: countryCode),
                    isActive: $showVerification,
                    label: { EmptyView() }
                )
            )
        }
    }
}
