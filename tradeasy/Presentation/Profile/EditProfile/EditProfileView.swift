//
//  ProfileView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation
import SwiftUI

struct EditProfileView: View {
    
    @EnvironmentObject var navigationController: NavigationController
    let userPreferences = UserPreferences()
    @State var showError = false
    @State var navigateToLoggin = false
    @State var showLogin = false
    @State private var isEditUsernamePresent = false
    @State private var isUpdatePasswordPresent = false
    @State private var isUpdateEmailPresent = false
    
    var body: some View {
        NavigationStack{
            NavigationLink(destination:
                            UpdateUsernameView(), isActive: $isEditUsernamePresent) {
                
                
            }
            NavigationLink(destination:
                            UpdatePasswordView(), isActive: $isUpdatePasswordPresent) {
                
                
            }
            NavigationLink(destination:
                            SendVerificationEmail(), isActive: $isUpdateEmailPresent){
                
            }
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
                            
                            
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10) // add padding to the HStack
                    
                    Text("Upload profile picture").foregroundColor(Color(CustomColors.blueColor)).bold().font(.system(size: 15)).padding(.top,10)
                    
                    Spacer()
                }
                .padding() // add padding to the VStack
                .background(Color("card_color"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.bottom,30)
                VStack {
                    EditProfileHstack(action: {
                        isEditUsernamePresent=true
                    }, image: "person.fill", text: "Username",rightText: (userPreferences.getUser()?.username)!)
                    Divider()
                    EditProfileHstack(action: {
                        
                    }, image: "phone.fill", text: "Phone Number",rightText: (userPreferences.getUser()?.phoneNumber)!)
                    Divider()
                    EditProfileHstack(action: {
                        isUpdateEmailPresent = true
                    }, image: "mail.fill", text: "Email",rightText: (userPreferences.getUser()?.email)!)
                    Divider()
                    EditProfileHstack(action: {
                        isUpdatePasswordPresent = true
                        
                    }, image: "lock.fill", text: "Password",rightText: "Change password")
                }
                    
                                    .padding() // add padding to the VStack
                                    .background(Color("card_color"))
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    .padding(.bottom,10)
                    
                }.onAppear {
                    
                    // Perform your action here
                    if userPreferences.getUser() == nil
                    {
                        showLogin = true
                        navigationController.navigate(to: LoginView())
                    }
                    
                    
                    
                }
            }
            
            
        }}
    
    
    struct EditProfileHstack: View {
        var action: () -> Void
        var image: String
        var text: String
        var rightText: String
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: image)
                        .foregroundColor(Color(CustomColors.greyColor))
                        .font(.headline)
                    
                    Text(text)
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .font(.system(size: 10))
                        .fontWeight(.regular)
                    
                    Spacer()
                    
                    Text(rightText)
                        .font(.headline)
                        .foregroundColor(Color(CustomColors.greyColor))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.leading, 70)
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundColor(Color(CustomColors.greyColor))
                        .font(.system(size: 10))
                        .fontWeight(.regular)
                }
            }
        }
    }

