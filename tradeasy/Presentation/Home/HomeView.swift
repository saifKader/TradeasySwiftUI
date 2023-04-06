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
                    // Items 1
                    VStack(alignment: .leading) {
                        Text("Items 1").font(.callout)
                            .font(.title)
                            .padding(.leading, 10)
                            .padding(.top, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(viewModel.products) { product in
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        ProductRowView(product: product)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    
                    // Items 2
                    VStack(alignment: .leading) {
                        Text("Items 2").font(.callout)
                            .font(.title)
                            .padding(.leading, 10)
                            .padding(.top, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(viewModel.products) { product in
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        ProductRowView(product: product)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Home").font(.headline)
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
    let product: Products
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            KFImage(product.imageUrl)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 200, minHeight: 200)
                .cornerRadius(10)
            
            Text(product.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(String(format: "$%.2f", product.price))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(product.description)
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


struct ProductDetailView: View {
    let product: Products
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            KFImage(product.imageUrl)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            Text(product.name)
                .font(.title)
            
            Text(product.description)
                .font(.body)
            
            Text(String(format: "$%.2f", product.price))
                .font(.headline)
        }
        .padding()
        .navigationBarTitle(Text(product.name), displayMode: .inline)
    }
}

class HomeViewModel: ObservableObject {
    @Published var products: [Products] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    init() {
        loadProducts()
    }
    
    func loadProducts() {
        isLoading = true
        
        // Replace this with your API call to load products
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.products = [
                Products(id: UUID(), name: "Product 1", price: 10.0, description: "This is product 1", imageUrl: URL(string: "https://picsum.photos/200/200")!),
                Products(id: UUID(), name: "Product 2", price: 20.0, description: "This is product 2", imageUrl: URL(string: "https://picsum.photos/200/200")!)
            ]
            
            self.isLoading = false
        }
    }
}
