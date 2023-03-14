//
//  Animations.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation
import SwiftUI

struct Shake: AnimatableModifier {
    var shakes: CGFloat = 0
    
    var animatableData: CGFloat {
        get {
            shakes
        } set {
            shakes = newValue
        }
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: sin(shakes * .pi * 2) * 5)
    }
}
