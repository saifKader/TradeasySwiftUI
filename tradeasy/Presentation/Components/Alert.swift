//
//  Alert.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation
import SwiftUI

class AlertHelper {
    static func showAlert(title: String, message: String) -> Alert {
        return Alert(
            title: Text(title),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
}

