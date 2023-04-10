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
        
        @State private var showImagePicker = false
        @State private var profileImage: UIImage?
    

        
        
        func uploadProfilePicture(_ image: UIImage) {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                print("Failed to convert image to data.")
                return
            }

            let url = "http://172.20.10.3:9090/user/uploadprofilepicture"
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "jwt": (userPreferences.getUser()?.token)!
            ]
            let fileName = "profilePicture.jpg"
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "profilePicture", fileName: fileName, mimeType: "image/jpeg")
            }, to: url, method: .post, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    print("Response JSON: \(json)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }

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
                                if let image = profileImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .padding(.top, 30)
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
                                               ImagePicker(selectedImage: $profileImage)
                                               
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
                    }, image: "person.fill", text: "Username",rightText: (userPreferences.getUser()?.username)!)
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

