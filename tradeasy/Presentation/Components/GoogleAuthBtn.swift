import SwiftUI
import AuthenticationServices
import GoogleSignIn

struct SignInWithGoogleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image("google") // Replace "google" with the name of your image asset
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20) // Adjust the size of the image as needed
                
                Text("Sign in with Google")
                    .foregroundColor(.black)
            }
            .frame(width: 250, height: 40)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2) // Add a slight shadow
        }
    }
}




