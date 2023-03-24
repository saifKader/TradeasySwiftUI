//
//  FocusedTextField.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 24/3/2023.
//

import SwiftUI

struct FocusedTextField: UIViewRepresentable {
    @Binding var text: String
    var keyboardType: UIKeyboardType
    var becomeFirstResponder: Bool
    var moveToNextField: () -> Void
    var moveToPreviousField: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = keyboardType
        textField.delegate = context.coordinator
        textField.textContentType = .oneTimeCode
        textField.textAlignment = .center
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if becomeFirstResponder {
            uiView.becomeFirstResponder()
        }
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FocusedTextField

        init(_ textField: FocusedTextField) {
            self.parent = textField
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 1
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
            if textField.text?.count == 1 {
                parent.moveToNextField()
            } else if textField.text?.count == 0 {
                parent.moveToPreviousField()
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
