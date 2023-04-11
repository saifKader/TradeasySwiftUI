//
//  SearchView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//



import SwiftUI


import SwiftUI

import SwiftUI

struct SearchView: View {
    @State var searchValue = ""
    @ObservedObject var viewModel = SearchProductViewModel()
    @State private var searchMessage = ""
    @State private var Prompt = "Search for you next best product"
    @EnvironmentObject var navigationController: NavigationController
    var prodNameReq: ProdNameReq {
        return ProdNameReq(name: searchValue)
    }
    
    @State private var productsList: [ProductModel] = []

    var body: some View {
        GeometryReader { geometry in
            VStack {
                SearchBar(text: $searchValue)
                    .frame(height: geometry.safeAreaInsets.top > 0 ? 50 : 44)
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? 0 : 10)

                if productsList.isEmpty {
                    if searchValue.isEmpty {
                                   Text(Prompt)
                                       .foregroundColor(.gray)
                                       .padding()
                                       .multilineTextAlignment(.center)
                               } else {
                                   Text(searchMessage)
                                       .foregroundColor(.gray)
                                       .padding()
                               }
                } else {
                    List {
                        ForEach(productsList, id: \._id) { product in
                            Button(action: {
                                navigationController.navigate(to: ProductDetailsView(product: product))
                            }) {
                                HStack {
                                    // Display the image from the URL
                                    if let imageUrl = product.image?.first,
                                       let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 100, height: 100)
                                        }
                                    } else {
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(width: 100, height: 100)
                                    }

                                    // Product's name and description
                                    VStack(alignment: .leading) {
                                        Text(product.name!)
                                            .font(.headline)
                                        Text(product.description!)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle()) // Add this to remove the default button styling
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.bottom)


                }
            }
            .padding(.horizontal)
            .onChange(of: searchValue) { newValue in
                
                
                if newValue.isEmpty {
                        // Clear products list and message if search text is empty
                        productsList = []
                        searchMessage = ""
                    } else {
                viewModel.searchProduct(prodName: prodNameReq) { result in
                    switch result {
                    case .success(let products):
                        productsList = products
                        searchMessage = products.isEmpty ? "No products found" : ""
                    case .failure(let error):
                        if case let UseCaseError.error(message) = error {
                            searchMessage = "\(message)\(newValue)"
                        } else {
                            searchMessage = "An error occurred while searching for products"
                        }
                    }
                }
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
            }
            .padding(.trailing, 10)
            .opacity(text.isEmpty ? 0 : 1)
        }
   
    }
}
