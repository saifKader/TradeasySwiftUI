import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}
struct AllCategoriesView: View {
    let productsList: [ProductModel]
    let categories: [CategoryModel]
    @State private var selectedCategory: String? = nil
    
    var body: some View {
        NavigationLink(destination: ProductsByCategoryView(productsList: productsList, category: selectedCategory ?? "")) {
            List(categories) { category in
                HStack {
                    Image(category.name!)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(category.name!)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    print("selected category is \(category.name)")
                    selectedCategory = category.name
                }
            }
            .navigationTitle("Categories")
        }
    }
}

