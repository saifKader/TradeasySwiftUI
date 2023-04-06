//
//  ActionButton.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation
import SwiftUI

struct AuthButton: View {
    var text: LocalizedStringKey
    var action: () -> Void
    var isEnabled: Bool
    var isLoading: Bool

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .foregroundColor(.white)
                } else {
                    Text(text)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(isEnabled ? Color("app_color") : Color(CustomColors.greyColor))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .disabled(!isEnabled || isLoading)
    }

}
