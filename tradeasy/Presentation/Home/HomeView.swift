//
//  HomeView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 6/4/2023.
//

import SwiftUI
import Kingfisher
import SDWebImageSwiftUI


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
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            TextField("Search", text: $searchText)
                                .font(.system(size: 16))
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 8)
                            }
                        }
                        .padding(.horizontal)
                        //.transition(.move(edge: .top))
                        //.animation(.easeInOut(duration: 0.3))
                    }
                    
                    
                    // Products for Sale
                    SectionView(title: "Products for Sale", products: viewModel.products.filter { !$0.forBid! && $0.username != currentUser?.username && (searchText.isEmpty || $0.name!.localizedCaseInsensitiveContains(searchText)) })
                    // Products Forbid - Less than 1 hour
                    SectionView(title: "TradesyFlesh", products: viewModel.products.filter { product in
                        if let bidEndDate = product.bidEndDate {
                            let remainingTime = TimeInterval(bidEndDate / 1000) - Date().timeIntervalSince1970
                            return product.forBid! && product.username != currentUser?.username && (searchText.isEmpty || product.name!.localizedCaseInsensitiveContains(searchText)) && remainingTime <= 3600
                        }
                        return false
                    })

                    // Products Forbid
                    SectionView(title: "Products Forbid", products: viewModel.products.filter { product in
                        if let bidEndDate = product.bidEndDate {
                            let remainingTime = TimeInterval(bidEndDate / 1000) - Date().timeIntervalSince1970
                            return product.forBid! && product.username != currentUser?.username && (searchText.isEmpty || product.name!.localizedCaseInsensitiveContains(searchText)) && remainingTime > 3600
                        }
                        return false
                    })

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
    @StateObject var timerManager: TimerManager
    init(product: ProductModel) {
        self.product = product
        if let bidEndDate = product.bidEndDate {
            let endDate = Date(timeIntervalSince1970: TimeInterval(bidEndDate / 1000))
            self._timerManager = StateObject(wrappedValue: TimerManager(endDate: endDate))
        } else {
            self._timerManager = StateObject(wrappedValue: TimerManager(endDate: Date()))
        }
    }
    func formatTime(_ seconds: Int) -> String {
        let days = seconds / (24 * 3600)
        let remainingSeconds = seconds % (24 * 3600)
        let hours = remainingSeconds / 3600
        let remainingMinutes = remainingSeconds % 3600
        let minutes = remainingMinutes / 60
        let remainingSeconds2 = remainingMinutes % 60
        
        if days > 0 {
            return String(format: "%d days, %02d:%02d:%02d", days, hours, minutes, remainingSeconds2)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds2)
        }
    }
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                WebImage(url: URL(string: kImageUrl + (product.image?.first ?? "")))
                    .resizable()
                    .placeholder {
                        // You can use a placeholder image or a custom view while the image is loading
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.1))
                    }
                    .indicator(.activity) // Show activity indicator while loading
                    .transition(.fade(duration: 0.5)) // Fade-in transition
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                if product.forBid! {
                    Text("Live Bid")
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
                    .font(.system(size: 18, weight: .semibold, design: .default))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(String(format: "$%.2f", product.price ?? 0))
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.secondary)
                
                let rating: Float = (product.rating?.reduce(0.0) { result, rating in
                    return result + rating.rating
                } ?? 0.0) / Float(product.rating?.count ?? 1)

                HStack(spacing: 2) {
                    RatingStarsView(rating: rating)
                    Text(String(format: "(%.1f)", rating))
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                }

                Divider()
                    .frame(height: 1)
                    .background(Color.secondary.opacity(0.3))
                    .padding(.vertical, 5)
                if let bidEndDate = product.bidEndDate, timerManager.remainingTime > 0 {
                    let endDate = Date(timeIntervalSince1970: TimeInterval(bidEndDate / 1000))
                    let remainingTime = timerManager.remainingTime
                    let timeString = formatTime(Int(remainingTime))
                    Text("Ends in \(timeString)")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                }
                else if (product.forBid!) {
                    HStack {
                        Spacer()
                        Text("Bid Ended")
                            .foregroundColor(.black)
                            .font(.system(size: 12, weight: .bold))
                        Spacer()
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("For sale")
                            .foregroundColor(.black)
                            .font(.system(size: 12, weight: .bold))
                        Spacer()
                    }
                }
                
            }
        }
        .padding()
        .background(Color(.systemGray5)) // Updated background color
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.bottom, 10)
        
        
    }
}



struct RatingStarsView: View {
    let rating: Float
    
    var body: some View {
        let fullStars = rating.isFinite ? Int(rating) : 0
        let hasHalfStar = rating - Float(fullStars) >= 0.5
        let emptyStars = hasHalfStar ? 4 - fullStars : 5 - fullStars
        
        HStack(spacing: 2) {
            ForEach(0..<fullStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(Color("app_color"))
                    .font(.system(size: 12))
            }
            
            if hasHalfStar {
                Image(systemName: "star.lefthalf.fill")
                    .foregroundColor(Color("app_color"))
                    .font(.system(size: 12))
            }
            
            ForEach(0..<emptyStars, id: \.self) { _ in
                Image(systemName: "star")
                    .foregroundColor(Color("app_color"))
                    .font(.system(size: 12))
            }
        }
    }
}

struct SectionView: View {
    let title: String
    let products: [ProductModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Add an icon before the title, depending on the section
                switch title {
                case "Products for Sale":
                    Image(systemName: "bag.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.green)
                    Divider()
                case "TradesyFlesh":
                    Image(systemName: "bolt.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.yellow)
                    Divider()
                case "Products Forbid":
                    Text("💰")
                    Divider()
                default:
                    EmptyView()
                }
                
                Text(title)
                    .font(Font.custom("Helvetica Neue Bold", size: 26))
                    .foregroundColor(Color(.label))

            }
            .padding(.leading, 20)
            .padding(.top, 20)
            
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
        .background(Color(.systemGray6))
        
        .padding(.bottom)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

