//
//  EditProductView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 16/4/2023.
//

import SwiftUI

struct EditProductView1: View {
    @ObservedObject var viewModel = EditProductViewModel()
    @Binding var product: ProductModel
    
    @State private var prod_id: String
    @State private var name: String
    @State private var description: String
    @State private var price: String
    @State private var category: String
    @State private var quantity: String
    @State private var bid_end_date: String
    @State private var forBid: Bool
    @State private var image: UIImage? = nil
    
    @State private var showAdditionalInfoView = false
    @Environment(\.presentationMode) var presentationMode
    
    init(product: Binding<ProductModel>) {
        _product = product
        _prod_id = State(initialValue: product.wrappedValue._id!)
        _name = State(initialValue: product.wrappedValue.name!)
        _description = State(initialValue: product.wrappedValue.description!)
        _price = State(initialValue: String(product.wrappedValue.price!))
        _category = State(initialValue: product.wrappedValue.category!)
        _quantity = State(initialValue: String(product.wrappedValue.quantity!))
        _bid_end_date = State(initialValue: product.wrappedValue.forBid ?? false ? String(product.wrappedValue.bidEndDate ?? 1) : "1 Minute")
        _forBid = State(initialValue: product.wrappedValue.forBid!)
        self.viewModel = viewModel // pass viewModel here
        
        
    }
    
    
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !(Double(price) == nil) &&
        !(Int(quantity) == nil)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
             
                CustomTextField(placeholder: "Product Name", text: $name)
                CustomTextField(placeholder: "Description", text: $description)
                CustomTextField(placeholder: "Price", text: $price, keyboardType: .decimalPad)
                CustomTextField(placeholder: "Quantity", text: $quantity, keyboardType: .numberPad)
                Spacer()
                NavigationLink(destination: EditProductView2(viewModel: viewModel, prod_id: $prod_id, name: $name, description: $description, price: $price, quantity: $quantity, category: $category, forBid: $forBid, bid_end_date: $bid_end_date, image: $image), isActive: $showAdditionalInfoView) {
                    Button(action: {
                        if isFormValid {
                            showAdditionalInfoView = true
                        }
                    }) {
                        Text("Next")
                            .foregroundColor(isFormValid ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color("app_color") : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .isDetailLink(false)
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Edit Product", displayMode: .inline)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .onAppear {
                if let images = product.image, let imageUrl = images.first {
                    viewModel.fetchCurrentImage(imageUrl: kImageUrl + imageUrl) { fetchedImage in
                        image = fetchedImage
                    }
                }
            }
        }
    }
}





