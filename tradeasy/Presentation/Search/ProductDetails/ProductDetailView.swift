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
    @EnvironmentObject var navigationController: NavigationController
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
                    Text("Category: \(product.category ?? "")")
                    Text("Price: \(String(format: "%.2f", product.price!) ) TND")


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


                  
                        Text(product.username!)
                   
                    }
                    if let phoneNumber = product.userPhoneNumber {
                        Button(action: {
                            let telephone = "tel://"
                            let formattedString = telephone + phoneNumber
                            guard let url = URL(string: formattedString) else { return }
                            UIApplication.shared.open(url)
                        }) {
                            Text(phoneNumber)
                        }
                    }

                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide default back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        navigationController.popToRoot()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.primary)
                    }
                }
            }
        }
    }
    }
 
