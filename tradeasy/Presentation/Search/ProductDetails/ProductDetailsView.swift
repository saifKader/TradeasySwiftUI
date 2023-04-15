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
    let productPreferences = ProductPreferences()
    @State private var isProductSaved = false
    @State private var showFullScreenImage = false
    
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
    func updateSavedProductStatus() {
        userDataViewModel.getUserData { result in
            switch result {
            case .success(let user):
                if let savedProducts = user.savedProducts {
                    self.isProductSaved = savedProducts.contains { $0._id == product._id }
                } else {
                    self.isProductSaved = false
                }
            case .failure(_):
                self.isProductSaved = false
            }
        }
    }
    
    
    
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(product.name ?? "")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Add an image view in the middle
                if let imageUrl = product.image?.first, let url = URL(string: imageUrl) {
                    NavigationLink("", destination: FullScreenImageView(url: url).edgesIgnoringSafeArea(.all), isActive: $showFullScreenImage).opacity(0)
                    Button(action: {
                        showFullScreenImage.toggle()
                    }) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: (UIScreen.main.bounds.width - 32)/1)
                        } placeholder: {
                            ProgressView()
                        }
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
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            if let userId = userPreferences.getUser()?._id, product.user_id == userId {
                Button(action: {
                    if !viewModel.isListingOrUnlisting {
                        viewModel.productListOrUnlist(productID: product._id ?? "")
                    }
                }) {
                    Text(viewModel.isProductListed ? "Unlist" : "List")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isListingOrUnlisting ? Color.gray : (viewModel.isProductListed ? Color("app_color") : Color("app_color")))
                        .cornerRadius(10)
                        .opacity(viewModel.isListingOrUnlisting ? 0.5 : 1.0)
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 20)
                
            }
            
            
            
            
            
            
            Button(action: {
                let userDataManager = UserDataManager()
                if isProductSaved {
                    viewModel.saveProduct(productID: product._id ?? "")
                    userDataManager.getUserDataAndUpdatePreferences { result in
                        switch result {
                        case .success(let userModel):
                            print("User logged in successfully: \(userModel)")
                            updateSavedProductStatus()
                        case .failure(let error):
                            if case let UseCaseError.error(message) = error {
                                print("Errordsds logging in: \(message)")
                            } else {
                                print("Error 111 in: \(error)")
                            }
                        }
                    }
                } else {
                    viewModel.saveProduct(productID: product._id ?? "")
                    userDataManager.getUserDataAndUpdatePreferences { result in
                        switch result {
                        case .success(let userModel):
                            print("User logged in successfully: \(userModel)")
                            updateSavedProductStatus()
                        case .failure(let error):
                            if case let UseCaseError.error(message) = error {
                                print("Errordsds logging in: \(message)")
                            } else {
                                print("Error 111 in: \(error)")
                            }
                        }
                    }
                }
            }) {
                Image(systemName: isProductSaved ? "bookmark.fill" : "bookmark")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .onAppear {
                viewModel.isProductListed = product.selling ?? false
            }
            .onAppear(perform: updateSavedProductStatus)
        }.onAppear(perform: {print("aaa")
            productPreferences.setProduct(product: product)
        })
    }
}

struct FullScreenImageView: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
        } placeholder: {
            ProgressView()
        }
    }
}
