//
//  ProductDetailView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 11/4/2023.
//

import Foundation
import SwiftUI
struct ProductDetailsView: View {
    var product: ProductModel
    @StateObject var viewModel = ProductDetailsViewModel()
    @StateObject var userDataViewModel = GetUserDataStateViewModel()
    @EnvironmentObject var navigationController: NavigationController
    let userPreferences = UserPreferences()
    
    func updateSavedProductStatus(completion: @escaping (Bool) -> Void) {
        userDataViewModel.getUserData { result in
            switch result {
            case .success(let user):
                if let savedProducts = user.savedProducts {
                    completion(savedProducts.contains { $0._id == product._id })
                } else {
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
        }
    }

    var isProductSaved: Bool {
        print(userPreferences.getUser()?.savedProducts)
        guard let user = userPreferences.getUser(), let savedProducts = user.savedProducts else { return false }
        
        return savedProducts.contains { $0._id == product._id }
    }


    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(product.name ?? "")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Add an image view in the middle
                if let imageUrl = product.image?.first, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width - 32)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(product.description ?? "")
                    .font(.body)
                
                // Add the other elements under the image
                VStack(alignment: .leading, spacing: 4) {
                    Text("Category: \(product.category ?? "")").padding(.bottom,5)
                    Text("Price: \(String(format: "%.2f", product.price!) ) TND").padding(.bottom,5)


                    HStack {
                        // Add user name and profile picture in a row
                        // Assuming there is a user property in the product model with name and profilePicture properties
                        // Update the property names according to your product model
                        if let userProfilePicture = product.userProfilePicture, let url = URL(string: userProfilePicture) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 40, height: 40)

                                Image(systemName: "person.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                        }


                  
                        Text(product.username!).padding(.bottom,5)
                   
                    }
               
                    Text(product.userPhoneNumber!).padding(.bottom,30)
                    
                    if let forBid = product.forBid, forBid {
                        VStack(alignment: .center, spacing: 4) {
                            HStack(alignment: .center) {
                                ActionButton(text: "Place bid", action: {
                                    
                                }, height: 20.0, width: .infinity, icon: "hammer.fill")
                            }
                        }.padding(.bottom,25)
                    }
                    VStack(alignment: .center, spacing: 4) {
                        HStack(alignment: .center) {
                            ActionButton(text: "Call \(product.username!)", action: {
                                if let phoneNumber = product.userPhoneNumber {
                                    let telephone = "tel://"
                                    let formattedString = telephone + phoneNumber
                                    guard let url = URL(string: formattedString) else { return }
                                    UIApplication.shared.open(url)
                                }
                            }, height: 20.0, width: .infinity, icon: "phone.fill")
                        }
                    }


                    
                
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            Button(action: {
                if isProductSaved {
                    viewModel.saveProduct(productID: product._id ?? "")
                } else {
                    viewModel.saveProduct(productID: product._id ?? "")
                }
                
                    print("ahawa")
                    print(isProductSaved)
                    print("ahawa2")
            }) {
                Image(systemName: isProductSaved ? "bookmark.fill" : "bookmark")
                    .font(.title2)
                    .foregroundColor(.blue)
            }

           
        }
    }
    }
 
