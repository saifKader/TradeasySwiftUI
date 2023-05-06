import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct AllCategoriesView: View {
    
    

    let categories = [        Category(name: "Electronics", imageName: "electronics"),        Category(name: "Real estate", imageName: "real estate"),        Category(name: "Motors", imageName: "motors"),           ]
    
    var body: some View {
        NavigationLink(destination: AllCategoriesView()) {
            List(categories) { category in
                HStack {
                    Image(category.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(category.name)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Categories")
        }
    }
}
