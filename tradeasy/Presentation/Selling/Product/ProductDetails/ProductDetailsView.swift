//
//  ProductDetailView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 11/4/2023.
//

import Foundation
import SwiftUI
struct ProductDetailsView: View {
    @State  var product: ProductModel
    @StateObject var viewModel = ProductDetailsViewModel()
    @StateObject var userDataViewModel = GetUserDataStateViewModel()
    @EnvironmentObject var navigationController: NavigationController
    @State private var bidEnded = false
    let productPreferences = ProductPreferences()
    @State private var isProductSaved = false
    @State private var showFullScreenImage = false
    @State private var showFullDescription = false
    @State private var showEdit = false
    @State private var isShowingBidView: Bool = false
    @State private var showEditView: Bool = false
    
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
                if let imageUrl = product.image?.first, let url = URL(string: kImageUrl + imageUrl) {
                    NavigationLink("", destination: FullScreenImageView(url: url).edgesIgnoringSafeArea(.all), isActive: $showFullScreenImage).opacity(0)
                    Button(action: {
                        showFullScreenImage.toggle()
                        print(kImageUrl + imageUrl)
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
           
                // Add the other elements under the image
                VStack(alignment: .leading, spacing: 4) {
                    
                    
                    HStack {
                        // Add user name and profile picture in a row
                        // Assuming there is a user property in the product model with name and profilePicture properties
                        // Update the property names according to your product model
                        if let userProfilePicture = product.userProfilePicture ?? userPreferences.getUser()?.profilePicture, let url = URL(string: kImageUrl + userProfilePicture) {
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
                        
                        
                        Text(product.username!)
                            .padding(.bottom,5)
                            .font(.system(size: 16, weight: .bold))
                        
                        Spacer() // Add Spacer to push the saved button to the right
                        
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
                    }
                    .padding(.bottom, 25)
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Category: \(product.category ?? "")")
                            .padding(.bottom,5)
                        Text("Price: \(String(format: "%.2f", product.price!) ) TND")
                            .padding(.bottom,5)
                        
                        ZStack(alignment: .bottomTrailing) {
                            Text(product.description ?? "")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .lineLimit(showFullDescription ? nil : 7)
                                .animation(.easeInOut, value: showFullDescription)
                                .padding(.bottom, 30)
                            Spacer() // Push the button to the bottom of the container
                            if product.description?.count ?? 0 > 7 * 50 {
                                Button(action: {
                                    showFullDescription.toggle()
                                }) {
                                    Text(showFullDescription ? "Show Less" : "Show More")
                                        .font(.footnote)
                                        .foregroundColor(.blue)
                                        .padding(.top, 4)
                                        .padding(.bottom, 8)
                                }
                                .padding(.trailing, 4)
                            }
                        }
                        
                        
                    }
                    
                    if let forBid = product.forBid, forBid {
                        VStack(alignment: .center, spacing: 4) {
                            HStack(alignment: .center) {
                                ActionButton(text: "Place bid", action: {
                                    isShowingBidView = true
                                }, height: 20.0, width: .infinity, icon: "hammer.fill")
                            }
                        }.padding(.bottom,25)
                        NavigationLink(destination: BidView(socketManager: SocketIOManager(product: product), bidEnded: $bidEnded), isActive: $isShowingBidView) {
                            EmptyView()
                        }
                    }
                   
                    if let userId = userPreferences.getUser()?._id, product.user_id == userId {
                        VStack(alignment: .center, spacing: 4) {
                            HStack(alignment: .center) {
                                ActionButton(text: "Edit product", action: {
                                    showEditView = true
                                }, height: 20.0, width: .infinity, icon: "pencil")
                            }
                        }.padding(.bottom,25)
                        NavigationLink(destination: EditProductView1(product: $product), isActive: $showEditView) {
                            EmptyView()
                        }
                    }
                    if let userId = userPreferences.getUser()?._id, product.user_id == userId {
                        
                        
                        VStack(alignment: .center, spacing: 4) {
                            HStack(alignment: .center) {
                                ActionButton(text: viewModel.isProductListed ? "Unlist" : "List", action: {
                                    if !viewModel.isListingOrUnlisting {
                                        viewModel.productListOrUnlist(productID: product._id ?? "")
                                    }
                                }, height: 20.0, width: .infinity)
                            }
                        }.padding(.bottom,25)
                        
                        
                
                        
                    }


                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            // Add NavigationLink to EditProductView here
            
          
            
        }.onAppear {
            viewModel.isProductListed = product.selling ?? false
            updateSavedProductStatus()
            productPreferences.setProduct(product: product)
        }
        
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
