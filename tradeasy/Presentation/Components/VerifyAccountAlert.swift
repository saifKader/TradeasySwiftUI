//
//  VerifyAccountAlert.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 26/4/2023.
//

import Foundation
import SwiftUI
struct ConfirmationAlert: View {
    let message: String
    let confirmAction: () -> Void
    
    @State private var showingAlert = false
    
    var body: some View {
        Button(action: {
            showingAlert = true
        }) {
            Text("Show Alert")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Confirmation"),
                  message: Text(message),
                  primaryButton: .default(Text("Confirm"), action: confirmAction),
                  secondaryButton: .cancel())
        }
    }
}
