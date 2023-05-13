//
//  PhoneNumber.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 13/5/2023.
//

import Foundation
func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
    let phoneRegex = #"^\d{8,}$"#
    let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
    return phonePredicate.evaluate(with: phoneNumber)
}
