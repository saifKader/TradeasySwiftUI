//
//  FocusedTextField.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 24/3/2023.
//

import Foundation
import SwiftUI

class CustomTextField: UITextField {
    var textDidChange: ((String) -> Void)?
    var moveToNextField: (() -> Void)?
    var moveToPreviousField: (() -> Void)?
    
    override func deleteBackward() {
        let previousText = text
        super.deleteBackward()
        if let text = text, text.isEmpty {
            moveToPreviousField?()
        } else if previousText != text {
            textDidChange?(text ?? "")
        }
    }
    
    override func insertText(_ text: String) {
        super.insertText(text)
        textDidChange?(text)
    }
}


struct FocusedTextField: UIViewRepresentable {
    @Binding var text: String
    var keyboardType: UIKeyboardType
    var becomeFirstResponder: Bool
    var moveToNextField: (() -> Void)?
    var moveToPreviousField: (() -> Void)?

    func makeUIView(context: Context) -> UITextField {
        let textField = CustomTextField()
        textField.keyboardType = keyboardType
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        return textField
    }

    func updateUIView(_ textField: UITextField, context: Context) {
        textField.text = text
        if becomeFirstResponder {
            textField.becomeFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FocusedTextField

        init(_ textField: FocusedTextField) {
            self.parent = textField
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let oldText = textField.text, let range = Range(range, in: oldText) else {
                return true
            }

            let newText = oldText.replacingCharacters(in: range, with: string)
            if newText.count > 1 {
                return false
            }

            parent.text = newText

            if string.isEmpty {
                parent.moveToPreviousField?()
            } else {
                parent.moveToNextField?()
            }

            return true
        }
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            if let customTextField = textField as? CustomTextField {
                customTextField.selectedTextRange = customTextField.textRange(from: customTextField.beginningOfDocument, to: customTextField.beginningOfDocument)
            }
            return true
        }
    }
}
