//
//  EditProductView2.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 16/4/2023.
//

import SwiftUI

struct EditProductView2: View {
    @ObservedObject var viewModel: EditProductViewModel
    @EnvironmentObject var navigationController: NavigationController
    @Binding var prod_id: String
    @Binding var name: String
    @Binding var description: String
    @Binding var price: String
    @Binding var quantity: String
    @Binding var category: String
    @Binding var forBid: Bool
    @Binding var bid_end_date: String
    @Binding var image: UIImage?
    @State var isShowingImagePickerLibrary = false
    @State var isShowingImagePicker = false
    @State private var showingActionSheet = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    
    @StateObject var categoryViewModel = CategoryViewModel()
    @State private var categoryList: [CategoryModel] = []
    
    func updateCategoryList() async {
        do {
            try await categoryViewModel.fetchCategories()
            if case let .categorySuccess(categories) = categoryViewModel.state {
                categoryList = categories
                print("First Category: \(categories[0].name)")// Add this print statement
            }
        } catch {
            // Handle error here
            print("Failed to fetch categories: \(error)")
        }
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    

    // Update the bid end dates according to your app's requirements
    let bidEndDates = ["1 Minute", "1 Hour", "1 Day", "1 Week"]
    var isFormValid: Bool {
        !category.isEmpty
    }
    
    var editProductReq: EditProductReq {
        return EditProductReq(
            prod_id: prod_id,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            price: Double(price) ?? 0.0,
            category: category,
            quantity: Int(quantity) ?? 0,
            bid_end_date: bid_end_date,
            forBid: forBid,
            image: image ?? UIImage()
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
                    ForEach(categoryList, id: \.self) { category in
                        Text(category.name!)
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
            }
            .listRowSeparator(.hidden)
            Section {
                            AuthButton(
                                text: "Save Changes",
                                action: {
                                    viewModel.editProduct(editProductReq: editProductReq) { result in
                                        switch result {
                                        case .success(let productModel):
                                            print("Product edited successfully: \(productModel)")
                                            
                                            DispatchQueue.main.async {
                                                navigationController.popToRoot() // Add this line
                                            }
                                        case .failure(let error):
                                            errorMessage = "Error editing product: \(error.localizedDescription)"
                                            showError = true
                                        }
                                    }
                                },
                                isEnabled: isFormValid,
                                isLoading: viewModel.isLoading
                            )
                            .alert(isPresented: $showError) {
                                Alert(title: Text("Edit Product"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                            }
                        }
        }.onAppear{
            
            Task {
                await updateCategoryList()
            }
        }
        .scrollContentBackground(.hidden)
        NavigationLink(destination: ImagePickerWithCrop(selectedImage: $image, sourceType: .camera), isActive: $isShowingImagePicker,label: { EmptyView() })
        NavigationLink(destination: ImagePickerWithCrop(selectedImage: $image, sourceType: .photoLibrary), isActive: $isShowingImagePickerLibrary,label: { EmptyView() })
    }
}



