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
                        
                        
                    }
                    Spacer()
                }
                .padding(.horizontal, 20) // add padding to the HStack
                
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
                    .padding(.bottom,50)
                    Button(action: {
                        //showError = true
                        userPreferences.removeUser()
                        DispatchQueue.main.async{navigationController.navigate(to: LoginView())}
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
                    }.padding(.horizontal)
                        .padding(.bottom)
                    
                }.onAppear {
                    
                    // Perform your action here
                    if userPreferences.getUser() == nil
                    {
                        showLogin = true
                        navigationController.navigate(to: LoginView())
                    }
                        
                 
                
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
