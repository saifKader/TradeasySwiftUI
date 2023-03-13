//
//  Register.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import SwiftUI
import CoreData


struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Create an account")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal, 5)
            .padding(.top, 150) //
            
            TextField("Username", text: $viewModel.username)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                .padding(.horizontal, 5)
                .padding(.top, 10)
            
            HStack {
                TextField("CC ", text: $viewModel.countryCode)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                    .frame(width: 70)
                
                
                
                TextField("Phone Number", text: $viewModel.phoneNumber)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
            }
            .padding(.horizontal, 5)
            .padding(.top, 5)
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                .padding(.horizontal, 5)
                .padding(.top, 5)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                .padding(.horizontal, 5)
                .padding(.top, 5)
            
            Button(action: {
                Task {
                    do {
                        let userModel = try await viewModel.registerUser()
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
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
            }
            
            Spacer()
        }
        .padding()
    }
}
