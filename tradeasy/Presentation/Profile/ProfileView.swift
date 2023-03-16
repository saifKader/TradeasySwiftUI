//
//  ProfileView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation
import SwiftUI

struct ProfileView: View {
   
    @EnvironmentObject var navigationController: NavigationController
    @Environment(\.presentationMode) var presentationMode
    let userPreferences = UserPreferences()
    
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .foregroundColor(Color.secondary)
                            .padding(.top, 30)
                        
                        Text((userPreferences.getUser()?.username)!)
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.bottom)
                    }
                    Spacer()
                }
                
                Divider()
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 10) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.secondary)
                        Text((userPreferences.getUser()?.email)!)
                            .foregroundColor(Color.secondary)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    HStack(spacing: 10) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.secondary)
                        Text((userPreferences.getUser()?.phoneNumber)!)
                            .foregroundColor(Color.secondary)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding()
                        
            Button(action: {
                navigationController.navigate(to: LoginView())
                DispatchQueue.main.async {userPreferences.removeUser()}
                 
            }) {
                HStack {
                    Image(systemName: "arrow.backward.circle.fill")
                        .foregroundColor(.white)
                    
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color("app_color"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
            }
                       .padding(.horizontal)
                       .padding(.bottom)
                   }
                   .background(Color.white.edgesIgnoringSafeArea(.all))
                   .navigationBarHidden(true)
               }
           }
        
