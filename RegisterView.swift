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
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding()
            
            TextField("Country Code", text: $viewModel.countryCode)
                .padding()
            
            TextField("Phone Number", text: $viewModel.phoneNumber)
                .padding()
            
            TextField("Email", text: $viewModel.email)
                .padding()
            
            SecureField("Password", text: $viewModel.password)
                .padding()
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding()
            
            Button(action: {
                Task {
                    do {
                        let userModel = try await viewModel.registerUser()
                        print("User registered successfully: \(userModel)")
                        // TODO: Navigate to the next screen
                    } catch RegisterError.passwordsDoNotMatch {
                        print("Passwords do not match")
                    } catch UseCaseError.email{
                        print("status")
                    }catch UseCaseError.networkError {
                        print("Network error")
                    } catch UseCaseError.decodingError {
                        print("Decoding error")
                    }
                    catch {
                        print("Unknown error")
                    }
                }
            }) {
                Text("Register")
            }
        }
        .padding()
    }
}
