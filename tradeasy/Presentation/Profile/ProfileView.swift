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
    @EnvironmentObject var userPreferences: UserPreferences
    @State var showError = false
    @State var navigateToLoggin = false
    @State var showLogin = false
    @State private var isEditProfileViewActive = false
    @State private var showImagePicker = false
    @State private var isRefreshing = false // Add this state variable for the refresh control
    @State private var isSavedProductsViewActive: Bool = false
    @State private var profileImage: UIImage?
    @State private var isRecentlyViewed: Bool = false
    @State private var isPrivacyPolicyViewActive = false
    
    
    @ObservedObject var viewModel = UploadProfilePictureViewModel()
    
    let productPreferences = ProductPreferences()
    
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    VStack {
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
                            } else if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 150, height: 150)
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(Color.secondary)
                                    .padding(.top, 30)
                            }
                        }
                        
                        
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                Text(((userPreferences.getUser()?.username) ?? "") )
                    .foregroundColor(Color(CustomColors.greyColor)).bold()// add padding to the HStack
                
                ActionButton(text: "editProfile", action: {
                    isEditProfileViewActive = true
                }, height: getScreenSize().width * 0.05, width: getScreenSize().height * 0.2, icon: "chevron.right")
                .padding(.top, 20)
                NavigationLink(destination: EditProfileView( profileImage: $profileImage), isActive: $isEditProfileViewActive) {
                            EmptyView()
                        }.navigationBarTitle("Profile")
                
                
                Spacer()
            }
            .padding() // add padding to the VStack
            .background(Color("card_color"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.bottom,50)
            Text("My Tradeasy")
                .foregroundColor(Color(CustomColors.greyColor))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,10)
            
            VStack {
                NavigationLink(
                    destination: SavedProductsView(productsList: userPreferences.getUser()?.savedProducts ?? []),
                    isActive: $isSavedProductsViewActive
                ) {
                    ProfileHstack(
                        action: {
                            isSavedProductsViewActive = true
                        },
                        image: "heart",
                        text: "Saved"
                    )
                }
                
                Divider()
                ProfileHstack(action: {
                    
                    
                }, image: "hammer", text: "Bids")
                Divider()
                if(productPreferences.getProducts() != nil){
                    NavigationLink(
                        destination: RecentlyViewedView(productsList: productPreferences.getProducts()!),
                        isActive: $isRecentlyViewed
                    ) {
                        ProfileHstack(
                            action: {
                                isRecentlyViewed = true
                            },
                            image: "clock.arrow.circlepath",
                            text: "Recently viewed"
                        )
                    }
                }}
            .padding() // add padding to the VStack
            .background(Color("card_color"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.bottom,10)
            Text("Content & Display")
                .foregroundColor(Color(CustomColors.greyColor))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,10)
            VStack {
                ProfileHstack(action: {
                    
                }, image: "bell", text: "Push notifications")
            }
            .padding() // add padding to the VStack
            .background(Color("card_color"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.bottom,10)
            Text("Support & Privacy")
                .foregroundColor(Color(CustomColors.greyColor))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,10)
            VStack{
                
              
                    ProfileHstack(action: {
                        
                    }, image: "exclamationmark.triangle", text: "Report a problem")
                
                
            Divider()
                NavigationLink(
                    destination: PrivacyPolicyView(),
                    isActive: $isPrivacyPolicyViewActive) {
                        
                    }
                    ProfileHstack(action: {
                     
                        isPrivacyPolicyViewActive = true
                    }, image: "lock", text: "Terms & conditions")
               
            }
            .padding() // add padding to the VStack
            .background(Color("card_color"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.bottom,10)
                
            
          
          
            
            
            
            
            
            
            
            
            
            
            
            Text("Change Account")
                .foregroundColor(Color(CustomColors.greyColor))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,10)
            VStack {
                ProfileHstack(action: {
                    
                    
                    DispatchQueue.main.async{
                        userPreferences.removeUser()
                        navigationController.navigate(to: LoginView())
                    }
                }, image: "arrowshape.left", text: "Logout")
            }
            .padding() // add padding to the VStack
            .background(Color("card_color"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.bottom,10)
            
            
        }.onAppear {
            if let profilePicture = userPreferences.getUser()?.profilePicture,
               let imageUrl = URL(string: kImageUrl + profilePicture) {
                // Load the image asynchronously
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        // Assign the downloaded image to profileImage on the main thread
                        DispatchQueue.main.async {
                            profileImage = image
                        }
                    }
                }.resume()
            } else if userPreferences.getUser() == nil
            {
                showLogin = true
                navigationController.navigate(to: LoginView())
            }
        }


        .navigationBarTitle("Profile")
        .refreshable {
            // Add the RefreshControl to the ScrollView
            isRefreshing = true
            //userPreferences.refreshUserData()
            isRefreshing = false
        }
    }
}



struct ProfileHstack: View {
    var action: () -> Void
    var image: String
    var text: String
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: image) // convert the string to an Image
                    .foregroundColor(Color(CustomColors.greyColor))
                    .font(.headline)
                
                Text(text)
                    .font(.headline)
                    .foregroundColor(Color.black)
                
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundColor(Color(CustomColors.greyColor))
            }
        }
    }
}
