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
    let userPreferences = UserPreferences()
    @State var showError = false
    @State var navigateToLoggin = false
    @State var showLogin = false
    @State private var isEditProfileViewActive = false
    @State private var showImagePicker = false
    @State private var isRefreshing = false // Add this state variable for the refresh control
       
    var body: some View {
        
        
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    VStack {
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
                NavigationLink(destination:
                     EditProfileView(), isActive: $isEditProfileViewActive) {
                                                           
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
                        ProfileHstack(action: {
                            
                        }, image: "heart", text: "Saved")
                        Divider()
                        ProfileHstack(action: {
                            
                        }, image: "hammer", text: "Bids")
                        Divider()
                        ProfileHstack(action: {
                            
                        }, image: "clock.arrow.circlepath", text: "Recently viewed")
                        
                      

                    }
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
                    VStack {
                        ProfileHstack(action: {
                            
                        }, image: "exclamationmark.triangle", text: "Report a problem")
                    }
                    .padding() // add padding to the VStack
                    .background(Color("card_color"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.bottom,10)
            Text("Login")
                .foregroundColor(Color(CustomColors.greyColor))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,10)
            VStack {
                ProfileHstack(action: {
                    userPreferences.removeUser()
                    DispatchQueue.main.async{navigationController.navigate(to: LoginView())}
                }, image: "arrowshape.left", text: "Logout")
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
                .navigationBarTitle("Profile")
                       
                        .refreshable {
                            // Add the RefreshControl to the ScrollView
                            isRefreshing = true
                            //userPreferences.refreshUserData()
                            isRefreshing = false
                        }
            }
    }


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(Item())
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
