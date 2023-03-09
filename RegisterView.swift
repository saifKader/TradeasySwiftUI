//
//  Register.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 9/3/2023.
//

import SwiftUI
import CoreData


struct RegisterView: View {
     @StateObject var registerViewModel = RegisterViewModel()

    var body: some View {
        VStack {
            TextField("Username", text: $registerViewModel.username)
            TextField("Phone Number", text: $registerViewModel.phoneNumber)
            TextField("Email", text: $registerViewModel.email)
            SecureField("Password", text: $registerViewModel.password)
            TextField("Profile Picture", text: $registerViewModel.profilePicture)
            TextField("Notification Token", text: $registerViewModel.notificationToken)
            TextField("Country Code", text: $registerViewModel.countryCode)

            Button("Register") {
                registerViewModel.register()
            }
        }
    }
}
