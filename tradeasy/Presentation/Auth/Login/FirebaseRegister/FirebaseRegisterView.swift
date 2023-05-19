//
//  RegisterView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import SwiftUI
import CoreData
import CountryPickerView


struct FirebaseRegisterView: View {
    @ObservedObject var viewModel = RegisterViewModel()

    @State var username = ""
    @State var countryCode = ""
    @State var phoneNumber = ""
    @State var email: String // Add email property
    @State var password = ""
    @State private var isPhoneNumberInvalid = false
    @State private var errorMessage = ""
    @State var showError = false
    @EnvironmentObject var navigationController: NavigationController
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var firebaseRegisterViewModel = FirebaseRegisterViewModel()
    @Binding var profilePicture : String
    
    @State private var selectedCountry: Country?
    
    
    let userPreferences = UserPreferences()
    
    private func getStrokeBorder(isInvalid: Bool) -> some View {
        return RoundedRectangle(cornerRadius: 10)
            .strokeBorder(isInvalid ? Color.red : Color.gray, lineWidth: isInvalid ? 3 : 1)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\d{8,}$"#
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }



    var firebaseRegisterReq: FirebaseRegisterReq {
        return FirebaseRegisterReq(
            username: username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            countryCode: countryCode.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: countryCode + phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ,
            email: email,
            profilePicture: profilePicture
        )
    }

    var isFormValid: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !countryCode.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty 
       
    }

    var body: some View {

        VStack(alignment: .leading) {
            
            HStack {
                Text("Complete your registration")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal, 5)
            .padding(.top, 120)
            
            TextField(LocalizedStringKey("Username"), text: $username)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                .padding(.horizontal, 5)
                .padding(.top, 10)
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
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            
            HStack {
                CountryPickerViewWrapper(selectedCountry: $selectedCountry)
                    .frame(width: 50, height: 44)
                    .padding()
                    .onAppear {
                        // set the initial selected country code
                        countryCode = selectedCountry?.phoneCode ?? "+216"
                    }
                    .onChange(of: selectedCountry) { country in
                        // update the view model's countryCode property when the selected country changes
                        countryCode = country?.phoneCode ?? "+216"
                    }
                VStack(alignment: .leading){
                    TextField(LocalizedStringKey("Phone Number"), text: $phoneNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(getStrokeBorder(isInvalid: isPhoneNumberInvalid))
                        .padding(.top, 5)
                    if isPhoneNumberInvalid {
                        Text("Invalid phone number")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .padding(.horizontal, 5)
                    } else {
                        Text("")
                            .opacity(0)
                    }
                }
                
            }
            .padding(.horizontal, 5)
            
           
            
    
  
            
            
            
            AuthButton(
                
                text: "Finish",
                action: {
                    
                   
    
                    isPhoneNumberInvalid = !isValidPhoneNumber(phoneNumber)
                  
                    if isPhoneNumberInvalid {
                        return
                    }
                    Task {
                        firebaseRegisterViewModel.firebaseRegister(firebaseRegisterReq: firebaseRegisterReq) { result in
                            switch result {
                            case .success(let userModel):
                                print("User logged in succeaaaaessfully: \(userModel)")
                                userPreferences.setUser(user: userModel)
                                navigationController.navigate(to: MainView())
                                print("sucesssssssssss")
                                // TODO: Navigate to the next screen
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
            )
            .padding(.bottom, 10)

            
            
        }
            
            .padding()
            .alert(isPresented: $showError) {
                AlertHelper.showAlert(title: "Register", message: errorMessage)
            }.navigationBarBackButtonHidden(true)
        }
    
    }




