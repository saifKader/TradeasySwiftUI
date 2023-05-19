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
    @EnvironmentObject var userPreferences: UserPreferences
    @Binding var profileImage: UIImage?
    @State var showError = false
    @State var navigateToLoggin = false
    @State var showLogin = false
    @State private var isEditUsernamePresent = false
    @State private var isUpdatePasswordPresent = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showImagePickerCamera = false
    @State private var showingActionSheet = false
    @State private var showImagePickerLibrary = false
    @State private var showCropView = false
    @State private var isUpdatePhoneNumberPresent = false
    
    @ObservedObject var viewModel = UploadProfilePictureViewModel()
    func navigateToCropView(with image: UIImage) {
        let cropView = CropView(image: $profileImage)
        
        
        
    }
    var body: some View {
        NavigationStack {
            NavigationLink(destination: UpdateUsernameView(), isActive: $isEditUsernamePresent) {}
            NavigationLink(destination: UpdatePasswordView(), isActive: $isUpdatePasswordPresent) {}
            NavigationLink(destination: UpdatePhoneNumberView(), isActive: $isUpdatePhoneNumberPresent) {}
            NavigationLink(destination: SendVerificationEmail(), isActive: $navigationController.isUpdateEmailPresent){}
            NavigationLink(destination: ImagePickerWithCrop(selectedImage: $profileImage, sourceType: .camera), isActive: $showImagePickerCamera,label: { EmptyView() })
            NavigationLink(destination: ImagePickerWithCrop(selectedImage: $profileImage, sourceType: .photoLibrary), isActive: $showImagePickerLibrary,label: { EmptyView() })
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            if let imageUrlString = userPreferences.getUser()?.profilePicture,
                               let imageUrl = URL(string: kImageUrl + imageUrlString) {
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
                    .padding(.horizontal, 10)
                    VStack {
                        Button(action: {
                            showingActionSheet = true
                        }) {
                            
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Edit picture")
                            }
                            .foregroundColor(.blue)
                            
                        }
                        .actionSheet(isPresented: $showingActionSheet) {
                            ActionSheet(title: Text("Upload profile picture"), buttons: [
                                .default(Text("Take Photo"), action: {
                                    showImagePickerCamera = true
                                    
                                }),
                                .default(Text("Choose from Library"), action: {
                                    
                                    showImagePickerLibrary = true
                                    
                                }),
                                .cancel()
                            ])
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color("card_color"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.bottom,30)
                
                VStack {
                    EditProfileHstack(action: {
                        isEditUsernamePresent=true
                    }, image: "person.fill", text: "Username", rightText: (userPreferences.getUser()?.username)!)
                    Divider()
                    EditProfileHstack(action: {
                        
                        isUpdatePhoneNumberPresent = true
                    }, image: "phone.fill", text: "Phone Number", rightText: (userPreferences.getUser()?.phoneNumber)!)
                    Divider()
                    EditProfileHstack(action: {
                        navigationController.isUpdateEmailPresent = true
                    }, image: "mail.fill", text: "Email",rightText: (userPreferences.getUser()?.email)!)
                    Divider()
                    
                    
                    EditProfileHstack(action: {
                        isUpdatePasswordPresent = true
                        
                    }, image: "lock.fill", text: "Password",rightText: "change password")
                }
                
                .padding() // add padding to the VStack
                .background(Color("card_color"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.bottom,10)
                
            }
            .navigationBarItems(
                   leading: Button(action: {
                       navigationController.popToRoot()
                   }) {
                       Image(systemName: "chevron.backward")
                           .foregroundColor(Color("font_color"))
                   }
               )
            .onAppear {
                // Perform your action here
                if userPreferences.getUser() == nil
                {
                    showLogin = true
                    navigationController.navigate(to: LoginView())
                }
                
            }
            .onChange(of: profileImage) { newImage in
                if let newImage = newImage {
                    navigateToCropView(with: newImage)
                    
                    viewModel.uploadProfilePicture(newImage) { result in
                        switch result {
                        case .success(let userModel):
                            // Update the profile picture in the ProfileView as well
                            DispatchQueue.main.async {
                                profileImage = newImage
                                if var currentUser = userPreferences.getUser() {
                                    currentUser.profilePicture = userModel.profilePicture
                                    userPreferences.setUser(user: currentUser)
                                    
                                    
                                }
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            print("error image")
                        }
                    }
                }
            }
        }
    }
}


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
                    .foregroundColor(Color("font_color"))
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

