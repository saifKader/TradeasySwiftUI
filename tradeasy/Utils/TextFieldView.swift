//
//  textFieldView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/5/2023.
//
//

import SwiftUI

struct TradeasyTextField: View {
    let placeHolder: String
    @Binding var textValue: String
    var keyboardType: UIKeyboardType
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeHolder)
                .foregroundColor(Color(.placeholderText))
                .offset(y: textValue.isEmpty ? 0 : -25)
                .scaleEffect(textValue.isEmpty ? 1: 0.8, anchor: .leading)
                .animation(.default)
            TextField("", text: $textValue)
                .keyboardType(keyboardType) // Apply the keyboardType here
        }
        .padding(.top, textValue.isEmpty ? 0 : 15)
        .frame(height: 52)
        .padding(.horizontal, 16)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1).foregroundColor(.gray))
        
    }
}

struct TradeasyTextEditor: View {
    let placeHolder: String
    @Binding var textValue: String

    var body: some View {
        ZStack(alignment: .topLeading) { // change the alignment to topLeading
            Text(placeHolder)
                .foregroundColor(Color(.placeholderText))
                .offset( y: textValue.isEmpty ? 0 : -25) // add x offset
                .scaleEffect(textValue.isEmpty ? 1: 0.8, anchor: .leading)
                .padding(.top,8)
                .padding(.horizontal,2)
                .animation(.default)
            TextEditor(text: $textValue)
                .scrollContentBackground(.hidden)
        }
        .padding(.top, textValue.isEmpty ? 0 : 15)
        .frame(height: 100)
        .padding(.horizontal, 16)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1).foregroundColor(.gray))
        
    }
}


