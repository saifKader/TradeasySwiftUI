//
//  RegisterView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import SwiftUI
import CoreData
import CountryPickerView


struct RegisterView: View {
    @ObservedObject var viewModel = RegisterViewModel()
    @State private var selectedCountry: Country?
    @State var username = ""
    @State var countryCode = ""
    @State var phoneNumber = ""
    @State var email = ""
    @State var password = ""
    @State private var isPasswordVisible = false
    @State private var isPasswordInvalid = false
    @State private var isEmailInvalid = false
    @State private var isPhoneNumberInvalid = false
    
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
        let phoneRegex = #"^(\+?\d{1,3}[ -]?)?\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }



    var registerReq: RegisterReq {
        return RegisterReq(
            username: username.trimmingCharacters(in: .whitespacesAndNewlines),
            countryCode: countryCode.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password
        )
    }

    var isFormValid: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !countryCode.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Create an account")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal, 5)
            .padding(.top, 150)

            TextField("Username", text: $username)
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
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(getStrokeBorder(isInvalid: isPasswordInvalid))
                        .padding(.horizontal, 5)
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
            .padding(.top, 5)
            
            TextField("Email", text: $email)
                .padding()
                .background(getStrokeBorder(isInvalid: isEmailInvalid))
                .padding(.horizontal, 5)
                .padding(.top, 5)
                .keyboardType(.emailAddress)

                        
                if isEmailInvalid {
                    Text("Email not valid")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(.horizontal, 5)
                    
                } else {
                    Text("")
                        .opacity(0)
                }
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                       
                } else {
                    SecureField("Password", text: $password)
                }

                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.secondary)
                }
                    
            }
            .padding()
            .background(getStrokeBorder(isInvalid: isPasswordInvalid))
            .padding(.horizontal, 5)
            .padding(.top, 5)
                    
            if isPasswordInvalid {
                Text("Password must be at least 8 characters.")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(.horizontal, 5)
                
            } else {
                Text("")
                    .opacity(0)
            }
            
            

            Button(action: {
                isPasswordInvalid = password.count < 8
                isEmailInvalid =  !isValidEmail(email)
                isPhoneNumberInvalid = !isValidPhoneNumber(phoneNumber)
                if isPasswordInvalid {
                    return
                }
                if isEmailInvalid {
                    return
                }
                if isPhoneNumberInvalid {
                    return
                }
               
                
                
                
                Task {
                    
                    do {
                        let userModel = try await viewModel.registerUser(registerReq: registerReq)
                        print("User registered successfully: \(userModel)")
                        // TODO: Navigate to the next screen
                    } catch UseCaseError.error(let message) {
                        print("API errror: \(message)")
                    } catch UseCaseError.networkError {
                        print("Network error")
                    } catch UseCaseError.decodingError {
                        print("Decoding error")
                    } catch {
                        print("Unknown error")
                    }
                }
             }) {
                Text("SIGN UP")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(isFormValid ? Color.red : Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                
            }.disabled(!isFormValid)
            
            Spacer()
        }
        .padding()
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}



