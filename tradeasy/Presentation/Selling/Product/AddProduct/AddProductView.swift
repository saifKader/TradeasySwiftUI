import SwiftUI

struct AddProductView: View {
    @ObservedObject var viewModel = AddProductViewModel()
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var image: UIImage? = nil
    
    @State private var category = "electronics"
    @State private var bid_end_date = "1 Minute"
    @State private var quantity = ""
    @State private var forBid = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showAdditionalInfoView = false
    @EnvironmentObject var navigationController : NavigationController
    
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !(Double(price) == nil) &&
        !(Int(quantity) == nil)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading ,spacing: 10) {
                Text("Product Details")
                    .font(.headline)
                  Text("Product Name")
                CustomTextField(placeholder: "", text: $name)
                Text("Description")
                CustomTextField(placeholder: "", text: $description)
                Text("Price")
                CustomTextField(placeholder: "", text: $price, keyboardType: .decimalPad)
                Text("Quantity")
                CustomTextField(placeholder: "", text: $quantity, keyboardType: .numberPad)
    
               
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
                .background(
                    NavigationLink(
                        destination: AdditionalInfoView(viewModel: viewModel, name: $name, description: $description, price: $price, quantity: $quantity, image: $image, category: $category, forBid: $forBid, bid_end_date: $bid_end_date),
                        isActive: $showAdditionalInfoView,
                        label: { EmptyView() }
                    )
                )
                
              
            }
            .padding()
           
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
                .fill(Color("bid_list"))
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
