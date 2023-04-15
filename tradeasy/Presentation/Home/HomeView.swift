//
//  HomeView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 6/4/2023.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Products for Sale
                    VStack(alignment: .leading) {
                        Text("Products for Sale")
                            .font(.title)
                            .padding(.leading, 10)
                            .padding(.top, 5)

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(viewModel.products.filter { !$0.forBid! }, id: \._id) { product in
                                    NavigationLink(destination: ProductDetailsView(product: product)) {
                                       
                                        ProductRowView(product: product)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 20)
                        }
                    }
                    
                    // Products Forbid
                    VStack(alignment: .leading) {
                        Text("Products Forbid")
                            .font(.title)
                            .padding(.leading, 10)
                            .padding(.top, 5)

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(viewModel.products.filter { $0.forBid! }, id: \._id) { product in
                                    NavigationLink(destination: ProductDetailsView(product: product)) {
                                        ProductRowView(product: product)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 20)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Home")
                        .font(.headline)
                }
            }
            .refreshable {
                viewModel.loadProducts()
            }
            .onAppear {
                viewModel.loadProducts()
            }
        }
    }
}
struct ProductRowView: View {
    let product: ProductModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            KFImage(URL(string: product.image?.first ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .cornerRadius(10)

            Text(product.name ?? "")
                .font(.headline)
                .foregroundColor(.primary)

            Text(String(format: "$%.2f", product.price ?? 0))
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(product.description ?? "")
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
