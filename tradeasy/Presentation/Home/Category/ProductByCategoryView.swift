//
//  SearchView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//



import SwiftUI
import Kingfisher

struct ProductsByCategoryView: View {
  
    let productsList: [ProductModel]
    let category: String

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if productsList.filter({ $0.category == category }).isEmpty {
                    Text("No products in this category")
                        .foregroundColor(.gray)
                        .padding()
                        .multilineTextAlignment(.center)
                } else {
                    List {
                        ForEach(productsList.filter({ $0.category == category }), id: \._id) { product in
                            NavigationLink(destination: ProductDetailsView(product: product)) {
                                HStack {
                                    // Display the image from the URL
                                    if let imageUrl = product.image?.first,
                                       let url = URL(string: kImageUrl + imageUrl) {
                                        KFImage(url)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    } else {
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(width: 100, height: 100)
                                    }

                                    // Product's name and description
                                    VStack(alignment: .leading) {
                                        Text(product.name!)
                                            .font(.headline)
                                        
                                        Text("\(String(product.price!)) TND")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle()) // Add this to remove the default button styling
                        }
                        NavigationLink(destination: AllProductsView(productsList: productsList)) {
                            Text("View All")
                                .font(.headline)
                                .foregroundColor(Color(CustomColors.blueColor))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color("background_color"))
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }.onAppear{
            
            print(productsList)
        }
        
    }
}
