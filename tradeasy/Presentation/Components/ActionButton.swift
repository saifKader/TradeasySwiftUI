//
//  ActionButton.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation
import SwiftUI

struct ActionButton: View {
    var text: LocalizedStringKey
    var action: () -> Void
    var height: CGFloat
    var width: CGFloat
    var icon: String

    var body: some View {
        Button(action: action) {
            ZStack {
                HStack {
                    Text(text)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Image(systemName: icon)
                        .foregroundColor(.white)
                }
            }
            .frame(width: width, height: height)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color("app_color"))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .frame(width: width, height: height)
    }
}
