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
    let currentUser = userPreferences.getUser()
    
    @State private var searchText: String = ""
    @State private var showSearchBar: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Search Bar
                    if showSearchBar {
                        SearchBar(text: $searchText)
                            .padding(.horizontal)
                            .transition(.move(edge: .top))
                            .animation(.default)
                    }
                    
                    // Products for Sale
                    SectionView(title: "Products for Sale", products: viewModel.products.filter { !$0.forBid! && $0.username != currentUser?.username && (searchText.isEmpty || $0.name!.localizedCaseInsensitiveContains(searchText)) })
                    
                    // Products Forbid
                    SectionView(title: "Products Forbid", products: viewModel.products.filter { $0.forBid! && $0.username != currentUser?.username && (searchText.isEmpty || $0.name!.localizedCaseInsensitiveContains(searchText)) })
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Home")
                        .font(.headline)
                        .foregroundColor(Color.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSearchBar.toggle() }, label: {
                        Image(systemName: "magnifyingglass")
                    })
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
            ZStack {
                KFImage(URL(string: kImageUrl + (product.image?.first ?? "")))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0)]), startPoint: .bottom, endPoint: .top)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                if product.forBid! {
                    Text("Bid")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .cornerRadius(10)
                        .offset(x: 60, y: -60)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(product.name ?? "")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(String(format: "$%.2f", product.price ?? 0))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)

                let rating: Float = (product.rating?.reduce(0.0) { result, rating in
                    return result + rating.rating
                } ?? 0.0) / Float(product.rating?.count ?? 1)

                let fullStars = Int(rating)
                let hasHalfStar = (rating - Float(fullStars)) >= 0.5

                HStack(spacing: 2) {
                    ForEach(0..<fullStars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.yellow)
                            .font(.system(size: 12))
                    }

                    if hasHalfStar {
                        Image(systemName: "star.lefthalf.fill")
                            .foregroundColor(Color.yellow)
                            .font(.system(size: 12))
                    }

                    ForEach(fullStars..<5, id: \.self) { _ in
                        Image(systemName: "star")
                            .foregroundColor(Color.yellow)
                            .font(.system(size: 12))
                    }

                    Text(String(format: "%.1f", rating))
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                }

            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.bottom, 10)
    }
}




struct SectionView: View {
    let title: String
    let products: [ProductModel]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.leading, 20)
                .padding(.top, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(products, id: \._id) { product in
                        NavigationLink(destination: ProductDetailsView(product: product)) {
                            ProductRowView(product: product)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
    }
}

