//
//  KeyboardDismiss.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation
import SwiftUI
import Combine

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}
