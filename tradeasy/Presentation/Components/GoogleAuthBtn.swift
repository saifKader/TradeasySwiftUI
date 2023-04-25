import SwiftUI
import AuthenticationServices
import GoogleSignIn


struct SignInWithGoogleButton: View {
    var width: CGFloat
    var action: () -> Void
    
    var body: some View {
        VStack {
                    GoogleSignInButtonView(action: action).frame(height: 5)
                        .frame(width: 10)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.white)) // Add a background with rounded edges
                        .clipShape(RoundedRectangle(cornerRadius: 25)) // Clip the GoogleSignInButtonView to match the rounded edges
                }
    }
}

struct GoogleSignInButtonView: UIViewRepresentable {
    var action: () -> Void
    
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.style = .wide // Set the button style to wide to reduce the width
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(action: action)
    }
    
    class Coordinator: NSObject {
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func buttonTapped() {
            action()
        }
    }
}



