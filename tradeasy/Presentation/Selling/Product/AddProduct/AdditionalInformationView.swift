//
//  AdditionalInformationView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 13/4/2023.
//

import SwiftUI

struct AdditionalInfoView: View {
    @ObservedObject var viewModel = AddProductViewModel()
    @StateObject var categoryViewModel = CategoryViewModel()
    @Binding var name: String
    @Binding var description: String
    @Binding var price: String
    @Binding var quantity: String
    @Binding var image: UIImage?
    
    @Binding var category: String
    @Binding var forBid: Bool
    @Binding var bid_end_date: String
    @EnvironmentObject var navigationController: NavigationController
    @State private var errorMessage = ""
    @State private var showError = false
    @State var isShowingImagePicker = false
    @State var isShowingImagePickerLibrary = false
    @State private var showingActionSheet = false
    @State private var categoryList: [CategoryModel] = []
    let categories = ["electronics", "motors","real estate","furniture","clothing"]
    let bidEndDates = ["1 Minute", "1 Hour", "1 Day", "1 Week"]
    var isFormValid: Bool {
        !(image == nil) &&
        !category.isEmpty
    }
    
    func updateCategoryList() async {
        do {
            try await categoryViewModel.fetchCategories()
            if case let .categorySuccess(categories) = categoryViewModel.state {
                
                categoryList = categories
                
            }
        } catch {
            // Handle error here
            print("Failed to fetch categories: \(error)")
        }
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
                        showingActionSheet = true
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
                    .actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("Select Image"), buttons: [
                            .default(Text("Take Photo"), action: {
                                isShowingImagePicker = true
                                
                            }),
                            .default(Text("Choose from Library"), action: {
                                
                                isShowingImagePickerLibrary = true
                                
                            }),
                            .cancel()
                        ])
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
                                    DispatchQueue.main.async {
                                        navigationController.popToRoot()
                                        //presentationMode.wrappedValue.dismiss()
                                    }
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
            .onAppear {
         
                Task {
                    await updateCategoryList()
                }
            }
        NavigationLink(destination: ImagePickerWithCrop(selectedImage: $image, sourceType: .camera), isActive: $isShowingImagePicker,label: { EmptyView() })
        NavigationLink(destination: ImagePickerWithCrop(selectedImage: $image, sourceType: .photoLibrary), isActive: $isShowingImagePickerLibrary,label: { EmptyView() })
    }
}
