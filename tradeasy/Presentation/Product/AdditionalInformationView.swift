//
//  AdditionalInformationView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 13/4/2023.
//

import SwiftUI

struct AdditionalInfoView: View {
    @ObservedObject var viewModel = AddProductViewModel()
    
    @Binding var name: String
    @Binding var description: String
    @Binding var price: String
    @Binding var quantity: String
    @Binding var image: UIImage?
    @Binding var isShowingImagePicker: Bool
    @Binding var category: String
    @Binding var forBid: Bool
    @Binding var bid_end_date: String
    
    @State private var errorMessage = ""
    @State private var showError = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let categories = ["electronics", "motors"]
    let bidEndDates = ["1 Minute", "1 Hour", "1 Day", "1 Week"]
    var isFormValid: Bool {
        !(image == nil) &&
        !category.isEmpty
    }

    var addProductReq: AddProductReq {
        return AddProductReq(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            price: Double(price) ?? 0.0,
            image: image ?? UIImage(),
            category: category,
            quantity: Int(quantity) ?? 0,
            bid_end_date: bid_end_date,
            forBid: forBid
        )
    }
    
    var body: some View {
        Form {
            Section(header: Text("Additional Information")) {
                Button(action: {
                    isShowingImagePicker.toggle()
                }) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 150, maxHeight: 150)
                    } else {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Select Image")
                        }
                        .foregroundColor(.blue)
                    }
                }
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $image)
                }
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                
                Toggle("Enable Bidding?", isOn: $forBid)
                if forBid {
                    Picker("Bid End Date", selection: $bid_end_date) {
                        ForEach(bidEndDates, id: \.self) { endDate in
                            Text(endDate)
                        }
                    }
                }
            }.listRowSeparator(.hidden)
            Section {
                AuthButton(
                    text: "Add Product",
                    action: {
                        viewModel.addProduct(addProductReq: addProductReq) { result in
                            switch result {
                            case .success(let productModel):
                                print("Product added successfully: \(productModel)")
                                presentationMode.wrappedValue.dismiss()
                            case .failure(let error):
                                errorMessage = "Error adding product: \(error.localizedDescription)"
                                showError = true
                            }
                        }
                    },
                    isEnabled: isFormValid,
                    isLoading: viewModel.isLoading
                )
                .alert(isPresented: $showError) {
                    Alert(title: Text("Add Product"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}
