//
//  SplashScreenView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 13/5/2023.
//
import SwiftUI
import Foundation


struct SplashView: View {
    @State var isActive: Bool = false
    let userPreferences = UserPreferences()
    var body: some View {
        ZStack {
            if self.isActive {
                MainView()
            } else {
                Rectangle()
                    .background(Color.black)
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
        }
        .edgesIgnoringSafeArea(.all) // Add this modifier to ignore the safe area
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    userPreferences.removeUser()
                    self.isActive = true
                }
            }
        }
    }
}
