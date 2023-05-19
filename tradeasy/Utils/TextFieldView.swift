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
    let maxLength: Int
    @Binding var textValue: String
    var keyboardType: UIKeyboardType
    
    private var limitedTextValue: Binding<String> {
        Binding<String>(
            get: { self.textValue },
            set: { newValue in
                if newValue.count <= maxLength {
                    self.textValue = newValue
                }
            }
        )
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeHolder)
                .foregroundColor(Color(.placeholderText))
                .offset(y: textValue.isEmpty ? 0 : -25)
                .scaleEffect(textValue.isEmpty ? 1: 0.8, anchor: .leading)
            TextField("", text: limitedTextValue)
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
    let maxLength: Int
    @Binding var textValue: String
    
    private var limitedTextValue: Binding<String> {
        Binding<String>(
            get: { self.textValue },
            set: { newValue in
                if newValue.count <= maxLength {
                    self.textValue = newValue
                }
            }
        )
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) { // change the alignment to topLeading
            Text(placeHolder)
                .foregroundColor(Color(.placeholderText))
                .offset( y: textValue.isEmpty ? 0 : -25) // add x offset
                .scaleEffect(textValue.isEmpty ? 1: 0.8, anchor: .leading)
                .padding(.top,8)
                .padding(.horizontal,2)
            TextEditor(text: limitedTextValue)
                .scrollContentBackground(.hidden)
        }
        .padding(.top, textValue.isEmpty ? 0 : 15)
        .frame(height: 100)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1).foregroundColor(.gray))
        
    }
}
