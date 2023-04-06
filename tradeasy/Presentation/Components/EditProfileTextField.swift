
import SwiftUI



struct EditProfileTextField: View {
    @State var text: String
    var onTextChanged: (String) -> Void
    var labelText: String = ""
    var secureInput: Bool = false

    var body: some View {
        Group {
            if secureInput {
                SecureField(labelText, text: $text)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                    .onChange(of: text, perform: { newValue in
                        onTextChanged(newValue)
                    })
            } else {
                TextField(labelText, text: $text)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                    .onChange(of: text, perform: { newValue in
                        onTextChanged(newValue)
                    })
            }
        }
    }
}
