//
//  Colors.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexValue = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexValue = hexValue.replacingOccurrences(of: "#", with: "")

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let redValue = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let greenValue = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blueValue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
}

struct CustomColors {
    static let redColor = UIColor(hexString: "#EB4A5A")
    static let greyColor = UIColor(hexString: "#ACABAD")
    static let backgroundColor = UIColor(hexString: "#F0F0F0")
    static let blueColor = UIColor(hexString: "#4B78A8")
}
