//
//  NewProductDetailView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 29/4/2023.
//

/*import SwiftUI

struct NewProductDetailView: View {
    @State  var product: ProductModel
    @StateObject var userDataViewModel = GetUserDataStateViewModel()
    @State private var userRating: Float = 0
    
    
    func getUserRatingCount(product: ProductModel) -> Int {
        guard let currentUserID = userPreferences.getUser()?._id else {
            return 0
        }
        if let userRating = product.rating?.first(where: { $0.user_id == currentUserID })?.rating {
            self.userRating = userRating
            return 1
        }
        return 0
    }
    init(product: ProductModel) {
        _product = State(initialValue: product)
        getUserRatingCount(product: product)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text(product.name ?? "")
            
            Spacer()
            
            
            
        })
        .ignoresSafeArea(.all, edges: .all)
        .background(Color(red: 1.0, green: 1.0, blue: 1.0))
        ).ignoresSafeArea(.all, edges:.all)
    }
}

*/



