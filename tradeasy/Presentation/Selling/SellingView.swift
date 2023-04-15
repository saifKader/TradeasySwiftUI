//
//  SellingView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/4/2023.
//

import SwiftUI

struct SellingView: View {
    @StateObject var viewModel = UserProductsViewModel()
    @State private var showAddProductView = false
    @EnvironmentObject var navigationController: NavigationController
    @State var showLogin = false
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Listed Products")
                                .font(.title)
                                .padding(.leading, 10)
                                .padding(.top, 5)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(viewModel.products.filter { $0.selling! }, id: \._id) { product in
                                        
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
                            Text("Unlisted Products")
                                .font(.title)
                                .padding(.leading, 10)
                                .padding(.top, 5)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(viewModel.products.filter { !$0.selling! }, id: \._id) { product in
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
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Sellings")
                                .font(.headline)
                        }
                    }
                    .refreshable {
                        viewModel.loadUserProducts()
                    }
                    .onAppear {
                        viewModel.loadUserProducts()
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingActionButton(onClick: {
                            showAddProductView = true
                        })
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
        }
        .onAppear {
            
            // Perform your action here
            if userPreferences.getUser() == nil
            {
                showLogin = true
                navigationController.navigate(to: LoginView())
            }
        }
    }
}

struct FloatingActionButton: View {
    let onClick: () -> Void

    var body: some View {
        NavigationLink(destination: AddProductView()) {
            ZStack {
                Circle()
                    .foregroundColor(Color("app_color"))
                    .frame(width: 60, height: 60)
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.white)
            }
        }
        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
    }
}

