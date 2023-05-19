//
//  ProfileView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import Foundation
import SwiftUI
import CoreData
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
    @State private var isChatBotViewActive = false
    @State private var showingLogoutAlert = false
    
    
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel = UploadProfilePictureViewModel()
    
    let productPreferences = ProductPreferences()
    @Environment(\.managedObjectContext) private var managedContext
    
    
    var body: some View {
        ScrollView() {
            VStack (spacing: 0){
                HStack {
                    Spacer()
                    VStack {
                        if userPreferences.getUser()?.isFirebase == true {
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
                        }else{
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
                        
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    let username = userPreferences.getUser()?.username ?? ""
                    Text(username.lowercased())
                        .bold()
                        .font(.custom("AvenirNext-DemiBold", size: 24))
                        .foregroundColor(Color("font_color"))
                    Spacer()
                    
                }
                
                ActionButton(text: "Edit Profile", action: {
                    navigationController.navigate(to: EditProfileView( profileImage: $profileImage))
                }, height: getScreenSize().width * 0.05, width: getScreenSize().height * 0.2)
                .padding(.top, 20)
                
                
                Spacer()
            }
            .padding() // add padding to the VStack
            .background(Color("card_color"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.bottom, 50)
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
            
            
            
            
            
            Text("Support & Privacy")
                .foregroundColor(Color(CustomColors.greyColor))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,10)
            VStack{
                
                NavigationLink(
                    destination: ChatBotView(),
                    isActive: $isChatBotViewActive) {
                        
                    }
                ProfileHstack(action: {
                    
                    isChatBotViewActive = true
                }, image: "hand.raised", text: "Assistance")
                
                
                Divider()
                Spacer()
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
            
            
            Text("Account")
                .foregroundColor(Color(CustomColors.greyColor))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,10)
            VStack {
                ProfileHstack(action: {
                    showingLogoutAlert = true
                    
                }, image: "arrowshape.left", text: "Logout")
            }
            .padding() // add padding to the VStack
            .background(Color("card_color"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.bottom,10)
            .alert(isPresented: $showingLogoutAlert) {
                Alert(title: Text("Logout Confirmation"),
                      message: Text("Are you sure you want to logout?"),
                      primaryButton: .destructive(Text("Logout")) {
                    Task {
                        await deleteAllNotifications(context: managedContext) { result in
                            switch result {
                            case .success(let notificationModels):
                                
                                print("success")
                            case .failure(let error):
                                print("Error fetching notifications from Core Data: \(error)")
                            }
                        }
                    }
                    DispatchQueue.main.async{
                        
                        userPreferences.removeUser()
                        navigationController.navigate(to: LoginView())
                        UserDefaults.standard.removeObject(forKey: "isDarkMode")
                    }
                },
                      secondaryButton: .cancel()
                )
            }
            
        }
        
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear {
            if let profilePicture = userPreferences.getUser()?.profilePicture {
                var imageUrl: URL?
                if userPreferences.getUser()?.isFirebase == true {
                    imageUrl = URL(string: profilePicture)
                } else {
                    imageUrl = URL(string: kImageUrl + profilePicture)
                }
                
                if let imageUrl = imageUrl {
                    // Load the image asynchronously
                    URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                        if let data = data, let image = UIImage(data: data) {
                            // Assign the downloaded image to profileImage on the main thread
                            DispatchQueue.main.async {
                                profileImage = image
                            }
                        }
                    }.resume()
                }
            } else if userPreferences.getUser() == nil {
                showLogin = true
                navigationController.navigate(to: LoginView())
            }
        }

        
        
        .navigationBarTitle("Profile")
        .refreshable {
            if let profilePicture = userPreferences.getUser()?.profilePicture {
                if userPreferences.getUser()?.isFirebase == true {
                    if let imageUrl = URL(string: profilePicture) {
                        // Load the image asynchronously
                        print("haho nayel\(profilePicture)")
                        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                // Assign the downloaded image to profileImage on the main thread
                                DispatchQueue.main.async {
                                    profileImage = image
                                }
                            }
                        }.resume()
                    }
                } else {
                    if let imageUrl = URL(string: kImageUrl + profilePicture) {
                        // Load the image asynchronously
                        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                // Assign the downloaded image to profileImage on the main thread
                                DispatchQueue.main.async {
                                    profileImage = image
                                }
                            }
                        }.resume()
                    }
                }
            } else if userPreferences.getUser() == nil {
                showLogin = true
                navigationController.navigate(to: LoginView())
            }
            isRefreshing = true
            // userPreferences.refreshUserData()
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
                    .foregroundColor(Color("font_color"))
                
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundColor(Color(CustomColors.greyColor))
            }
        }
    }
}
