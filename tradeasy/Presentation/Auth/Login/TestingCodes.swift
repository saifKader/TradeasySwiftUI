//
//  TestingCodes.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 29/5/2023.
//

import SwiftUI

struct LoginView1: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                Image("app_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.4)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 20) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white.opacity(0.2)))
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white.opacity(0.2)))
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    // Perform login action here
                    // You can validate the username and password and handle the login logic
                    
                    // For this example, let's simply print the credentials
                    print("Username: \(username)")
                    print("Password: \(password)")
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("app_color"))
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView1()
            .preferredColorScheme(.dark)
    }
}
