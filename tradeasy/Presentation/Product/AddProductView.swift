import SwiftUI

struct AddProductView: View {
    @ObservedObject var viewModel = AddProductViewModel()
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var image: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var category = "electronics"
    @State private var bid_end_date = "1 Minute"
    @State private var quantity = ""
    @State private var forBid = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showAdditionalInfoView = false

    @Environment(\.presentationMode) var presentationMode
    
    
    
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !(Double(price) == nil) &&
        !(Int(quantity) == nil)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Product Details")) {
                    CustomTextField(placeholder: "Product Name", text: $name)
                    CustomTextField(placeholder: "Description", text: $description)
                    CustomTextField(placeholder: "Price", text: $price, keyboardType: .decimalPad)
                    CustomTextField(placeholder: "Quantity", text: $quantity, keyboardType: .numberPad)
                }.listRowSeparator(.hidden)
                
                NavigationLink(destination: AdditionalInfoView(viewModel: viewModel, name: $name, description: $description, price: $price, quantity: $quantity, image: $image, isShowingImagePicker: $isShowingImagePicker, category: $category, forBid: $forBid, bid_end_date: $bid_end_date), isActive: $showAdditionalInfoView) {
                    EmptyView()
                }.frame(width: 0, height: 0)
                    .hidden()
                
                AuthButton(
                    text: "Next",
                    action: {
                        if isFormValid {
                            showAdditionalInfoView = true
                        }
                    },
                    isEnabled: isFormValid,
                    isLoading: false
                )
            }
            .scrollContentBackground(.hidden)
            .navigationBarTitle("Add Product", displayMode: .inline)
            .padding(.top, 30)
            .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }

    }
}





struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 3)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(.horizontal)
        }
        .frame(height: 50)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
