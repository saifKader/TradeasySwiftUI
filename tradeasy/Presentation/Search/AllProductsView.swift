//
//  SearchView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 10/4/2023.
//



import SwiftUI




struct AllProductsView: View {
    let productsList: [ProductModel]
    @EnvironmentObject var navigationController: NavigationController
    @State private var filteredProducts: [ProductModel]
    @State var showProductDetails = false
    init(productsList: [ProductModel]) {
        self.productsList = productsList
        self._filteredProducts = State(initialValue: productsList)
    }
    func applyFilter(filter: String) {
        switch filter {
        case "PriceAscending":
            // Apply filter based on Option1 (ascending price)
            self.filteredProducts = self.productsList.sorted { (product1, product2) -> Bool in
                guard let price1 = product1.price, let price2 = product2.price else {
                    return false
                }
                return price1 < price2
            }
        case "PriceDescending":
            // Apply filter based on Option2 (descending price)
            self.filteredProducts = self.productsList.sorted { (product1, product2) -> Bool in
                guard let price1 = product1.price, let price2 = product2.price else {
                    return false
                }
                return price1 > price2
            }
        case "ForBid":
            // Apply filter based on products with bid set to true
            self.filteredProducts = self.productsList.filter { product in
                return product.forBid == true
            }
        default:
            // Reset the filter
            self.filteredProducts = self.productsList
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if filteredProducts.isEmpty {
                    Text("Sorry, there are no products that match your criteria. Please try with different filter options")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(filteredProducts, id: \._id) { product in
                            Button(action: {
                                navigationController.navigateAnimation(to: ProductDetailsView(product: product), type: .productDetailsView)
                            }) {
                                    HStack {
                                        // Display the image from the URL
                                        if let imageUrl = product.image?.first,
                                           let url = URL(string: kImageUrl + imageUrl) {
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
                                            Text("\(String(product.price!)) TND")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle()) // Add this to remove the default button styling
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Menu {
                Button(action: { applyFilter(filter: "PriceAscending") }) {
                    HStack(spacing: 0) {
                        Image(systemName: "arrow.up")
                        Text("Price")
                    }
                }
                
                Button(action: { applyFilter(filter: "PriceDescending") }) {
                    HStack(spacing: 0) {
                        Image(systemName: "arrow.down")
                        Text("Price")
                    }
                }
                
                Button(action: { applyFilter(filter: "ForBid") }) {
                    HStack(spacing: 0) {
                        Image(systemName: "hammer.fill")
                        Text("For Bid")
                    }
                }
                
                Button(action: { applyFilter(filter: "Reset") }) {
                    HStack(spacing: 0) {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                        Text("Reset")
                    }
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundColor(Color("app_color"))
            }
            )
        }
    }
}
