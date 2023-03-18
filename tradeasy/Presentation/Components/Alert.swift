//
//  Alert.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation
import SwiftUI

class AlertHelper {
    
    
    typealias MethodHandler2 = ()  -> Void
    
    static func showAlert(title: String, message: String) -> Alert {
        return Alert(
            title: Text(title),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
    
    
    static func logoutAlert(title: String, message: String,actionClosure: @escaping () -> Void) -> Alert {
        return Alert(
            title: Text(title),
            primaryButton: .destructive(Text("Confirm")) {
                actionClosure()
                           },
                           secondaryButton: .cancel()
        )
    }
    
    
}

