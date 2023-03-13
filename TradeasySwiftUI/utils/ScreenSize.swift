//
//  ScreenSize.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 13/3/2023.
//

import Foundation
import SwiftUI
func getScreenSize() -> (width: CGFloat, height: CGFloat) {
    let screenSize = UIScreen.main.bounds.size
    return (width: screenSize.width, height: screenSize.height)
}
