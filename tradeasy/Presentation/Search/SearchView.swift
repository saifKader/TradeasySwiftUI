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
                    Text(searchMessage)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(productsList, id: \._id) { product in
                            // Customize this view to display the product information as needed
                            VStack(alignment: .leading) {
                                Text(product.name!)
                                    .font(.headline)
                                Text(product.description!)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                }
            }
            .padding(.horizontal)
            .onChange(of: searchValue) { newValue in
                viewModel.searchProduct(prodName: prodNameReq) { result in
                    switch result {
                    case .success(let products):
                        productsList = products
                        searchMessage = products.isEmpty ? "No products found" : ""
                    case .failure(let error):
                        if case let UseCaseError.error(message) = error {
                            searchMessage = message
                        } else {
                            searchMessage = "An error occurred while searching for products"
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
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 10)
            .opacity(text.isEmpty ? 0 : 1)
        }
   
    }
}
