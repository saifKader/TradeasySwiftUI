//
//  RegisterViewModel.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var password = ""

    private let userAPI: UserDataSource

    init(userAPI: UserDataSource = UserAPIImpl()) {
        self.userAPI = userAPI
    }

    func register() {
        async {
            do {
                let authResponse = try await userAPI.register(username: username, phoneNumber: phoneNumber, email: email, password: password)
                // Registration successful
                // Save the token and user information to the app's data store
            } catch {
                // Registration failed
                print("Error registering user: \(error)")
            }
        }
    }
}
