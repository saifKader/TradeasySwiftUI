//
//  ProfileView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation
import SwiftUI
import Alamofire

struct EditProfileView: View {
    
        @EnvironmentObject var navigationController: NavigationController
        let userPreferences = UserPreferences()
        @State var showError = false
        @State var navigateToLoggin = false
        @State var showLogin = false
        @State private var isEditUsernamePresent = false
        @State private var isUpdatePasswordPresent = false
    @Environment(\.presentationMode) var presentationMode
        @State private var showImagePicker = false
        @State private var uploadedImage: UIImage?
        @State private var profileImage: UIImage?

    @ObservedObject var viewModel = UploadProfilePictureViewModel()


        
        

        var body: some View {
            NavigationStack{
                NavigationLink(destination:
                                UpdateUsernameView(), isActive: $isEditUsernamePresent) {
                    
                    
                }
                NavigationLink(destination:
                                UpdatePasswordView(), isActive: $isUpdatePasswordPresent) {
                    
                    
                }
                NavigationLink(destination:
                                SendVerificationEmail(), isActive: $navigationController.isUpdateEmailPresent){
                    
                }
                ScrollView {
                    
                    VStack {
                        HStack {
                            Spacer()
                            VStack {
                                if let imageUrlString = userPreferences.getUser()?.profilePicture,
                                              let imageUrl = URL(string: imageUrlString) {
                                               AsyncImage(url: imageUrl) { phase in
                                                   switch phase {
                                                   case .success(let image):
                                                       image
                                                           .resizable()
                                                           .scaledToFit()
                                                           .clipShape(Circle())
                                                           .frame(width: 150, height: 150)
                                                   case .failure:
                                                       Image(systemName: "person.fill")
                                                           .resizable()
                                                           .scaledToFit()
                                                   default:
                                                       ProgressView()
                                                   }
                                               }
                                           } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(Color.secondary)
                                        .padding(.top, 30)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 10) // add padding
                        VStack {
                                               Button(action: {
                                                   showImagePicker = true
                                                   
                                                   
                                                   
                                               }) {
                                                   Text("Upload profile picture")
                                                       .foregroundColor(Color.blue)
                                                       .bold()
                                                       .font(.system(size: 15))
                                                       .padding(.top, 10)
                                               }
                                           }
                                           .sheet(isPresented: $showImagePicker) {
                                               ImagePicker(selectedImage: $uploadedImage)
                                               
                                           } .onChange(of: uploadedImage) { newImage in
                                               if let newImage = newImage {
                                                   viewModel.uploadProfilePicture(newImage) { result in
                                                       switch result {
                                                       case .success(let userModel):
                                               
                                                           
                                                           print("User logged in successfully: \(userModel)")
                                                           DispatchQueue.main.async {
                                                               print("aaaaa\(userModel)")
                                                               userPreferences.setUser(user: userModel)
                                                           }
                                                           self.presentationMode.wrappedValue.dismiss()
                                                       case .failure(let error):
                                                           if case let UseCaseError.error(message) = error {
                                                               print("Error logging in: \(message)")
                                                           } else {
                                                               print("Error logging in: \(error)")
                                                           }
                                                       }
                                                   }
                                               }
                                           }
                                       
               
                           
                    
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
                    }, image: "person.fill",
                                      
                                      
                                      text: "Username",rightText: (userPreferences.getUser()?.username)!)
                    Divider()
                    EditProfileHstack(action: {
                        
                    }, image: "phone.fill", text: "Phone Number",rightText: (userPreferences.getUser()?.phoneNumber)!)
                    Divider()
                    EditProfileHstack(action: {
                        navigationController.isUpdateEmailPresent = true
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

