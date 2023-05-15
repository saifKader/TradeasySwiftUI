//
//  ProductDetailView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 11/4/2023.
//

import Foundation
import SwiftUI
struct ProductDetailsView: View {
    @State  var product: ProductModel
    @StateObject var viewModel = ProductDetailsViewModel()
    @StateObject var userDataViewModel = GetUserDataStateViewModel()
    @EnvironmentObject var navigationController: NavigationController
    @State private var bidEnded = false
    let productPreferences = ProductPreferences()
    @State private var isProductSaved = false
    @State private var showFullScreenImage = false
    @State private var showFullDescription = true
    @State private var showEdit = false
    @State private var isShowingBidView: Bool = false
    @State private var showEditView: Bool = false
    @State private var userRating: Float = 0
    private let profilePictureSize: CGFloat = 40
    @State private var isAnimating = false
    
    init(product: ProductModel) {
        _product = State(initialValue: product)
        getUserRatingCount(product: product)
    }
    
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
    func updateSavedProductStatus(completion: @escaping (Bool) -> Void) {
        userDataViewModel.getUserData { result in
            switch result {
            case .success(let user):
                if let savedProducts = user.savedProducts {
                    completion(savedProducts.contains { $0._id == product._id })
                } else {
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
        }
    }
    func updateSavedProductStatus() {
        userDataViewModel.getUserData { result in
            switch result {
            case .success(let user):
                if let savedProducts = user.savedProducts {
                    self.isProductSaved = savedProducts.contains { $0._id == product._id }
                } else {
                    self.isProductSaved = false
                }
            case .failure(_):
                self.isProductSaved = false
            }
        }
    }
    func getRatingForUser(product: ProductModel, userId: String) -> Rating? {
        return product.rating?.first(where: { $0.user_id == userId })
    }

    
    //views
    func getImageView(url: URL?) -> some View {
        Group {
            if let imageUrl = url {
                // Show the full screen image view when the image is tapped
                ZStack {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .cornerRadius(20)
                            .padding(.horizontal, 20)
                    } placeholder: {
                        ProgressView()
                    }
                }
                .clipped()
                .onTapGesture {
                    showFullScreenImage.toggle()
                }
                .sheet(isPresented: $showFullScreenImage) {
                    FullScreenImageView(url: imageUrl)
                }
            } else {
                Rectangle()
                    .fill(Color.gray)
            }
        }
    }
    
    func getProfilePictureView(url: URL?) -> some View {
        Group {
            if let userProfilePictureUrl = url {
                AsyncImage(url: userProfilePictureUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
    
    func getSaveButton() -> some View {
        Button(action: {
            let userDataManager = UserDataManager()
            if isProductSaved {
                viewModel.saveProduct(productID: product._id ?? "")
            } else {
                viewModel.saveProduct(productID: product._id ?? "")
            }
            userDataManager.getUserDataAndUpdatePreferences { result in
                switch result {
                case .success(let userModel):
                    print("User logged in successfully: \(userModel)")
                    updateSavedProductStatus()
                case .failure(let error):
                    if case let UseCaseError.error(message) = error {
                        print("Error logging in: \(message)")
                    } else {
                        print("Error in: \(error)")
                    }
                }
            }
            isAnimating = true // Set animation flag to true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // After 0.5 seconds, set animation flag to false
                withAnimation(.easeInOut(duration: 0.5)) {
                    isAnimating = false
                }
            }
        }) {
            Image(systemName: isProductSaved ? "heart.fill" : "heart")
                .foregroundColor(isProductSaved ? Color("app_color") : Color("app_color"))
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isAnimating ? 1.2 : 1.0) // Scale the button up when animation flag is true
    }
    
    func getDescriptionView() -> some View {
        let description = product.description ?? ""
        let showButton = description.count > 100
        let maxLines = showFullDescription ? nil : 3
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Description:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                Spacer()
            }
            .padding(.top, 5)
            
            Text(description)
                .font(.body)
                .lineLimit(maxLines)
                .animation(.easeInOut, value: showFullDescription)
            HStack{
                Spacer()
                if showButton {
                    Button(action: {
                        showFullDescription.toggle()
                    }) {
                        Text(showFullDescription ? "Show more" : "Show less ")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        
        .padding(.horizontal, 20)
        .frame(height: showFullDescription ? nil : 200) // set the frame height to nil if showFullDescription is true, otherwise set it to 200
        .animation(.easeInOut, value: showFullDescription)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
    }

    func getBidButtonView() -> some View {
        VStack(alignment: .center, spacing: 4) {
            Button(action: { isShowingBidView = true }) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "hammer.fill")
                        .foregroundColor(.white)
                    
                    Text("Place bid")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                }
                .frame(height: 40.0)
                .frame(maxWidth: .infinity)
                .background(Color("app_color"))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.bottom, 25)
        .background(
            NavigationLink(destination: BidView(socketManager: SocketIOManager(product: product), bidEnded: $bidEnded, productId: product._id!), isActive: $isShowingBidView) {
                EmptyView()
            }
        )
    }
    
    func getEditButtonView() -> some View {
        VStack(alignment: .center, spacing: 4) {
            Button(action: { showEditView = true }) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                    
                    Text("Edit")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                }
                .frame(height: 40.0)
                .frame(maxWidth: .infinity)
                .background(Color("app_color"))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.bottom, 25)
        .background(
            NavigationLink(destination: EditProductView1(product: $product), isActive: $showEditView) {
                EmptyView()
            }
        )
    }
    
    func getListUnlistButtonView() -> some View {
        VStack(alignment: .center, spacing: 4) {
            Button(action: {
                if !viewModel.isListingOrUnlisting {
                    viewModel.productListOrUnlist(productID: product._id ?? "")
                }
            }) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: viewModel.isProductListed ? "heart.slash.fill" : "heart.fill")
                        .foregroundColor(viewModel.isProductListed ? Color("app_color") : Color("app_color"))
                    
                    Text(viewModel.isProductListed ? "Unlist" : "List")
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.isProductListed ? Color("app_color") : Color("app_color"))
                    
                }
                .frame(height: 40.0)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("app_color"), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.bottom, 25)
    }
    
    func formatPrice(_ price: Double?) -> String {
        guard let price = price else {
            return ""
        }
        return String(format: "%.2f", price) + "$"
    }
    
    func getCategoryView() -> some View {
        HStack(alignment: .center, spacing: 5) {
            Image(systemName: "tag.fill")
                .font(.system(size: 16))
                .foregroundColor(Color("app_color"))
            Text(product.category ?? "")
                .font(.system(size: 16))
        }
    }
    
    func getRatingView() -> some View {
        HStack {
            Text("Rating:")
            RatingView(rating: $userRating, maxRating: 5, product: product, viewModel: viewModel)
        }
        .padding(.bottom, 5)
    }

    func onAppearSetup() {
        viewModel.isProductListed = product.selling ?? false
        updateSavedProductStatus()
        
        productPreferences.setProduct(product: product)
        if let user = userPreferences.getUser() {
            _ = getUserRatingCount(product: product)
        }
    }
    
    //views
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Extracted the image view to a separate method to reduce nesting.
                // Used guard statements to unwrap optionals early in the code.
                getImageView(url: URL(string: kImageUrl + (product.image?.first ?? "")))
                
                // Extracted the card view to a separate method to reduce nesting.
                getCardView()
                
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color(.systemGray6))
        .onAppear {
            // Extracted the code to a separate method for readability.
            onAppearSetup()
        }
    }
    
    func getCardView() -> some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    
                        Text(product.name ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("font_color"))
                        
                    Spacer() // Add Spacer to push the saved button to the right
                    VStack(alignment: .trailing, spacing: 10) {
                        getSaveButton()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack{
                        // Add user name and profile picture in a row
                        if let userProfilePicture = product.userProfilePicture ?? userPreferences.getUser()?.profilePicture, let url = URL(string: kImageUrl + userProfilePicture) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        
                        Text(product.username ?? "")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.bottom, 5)
                    }
                    HStack{
                        getCategoryView()
                        Spacer()
                        // Used number formatter to format price value.
                        Text(formatPrice(Double(product.price ?? 0)))
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color("app_color"))
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .layoutPriority(1) // Ensure that the card width is not overridden by other views
                
                // Extracted the description view to a separate method to reduce nesting.
                // Wrap the description view in a ZStack to show the full description.
                ZStack(alignment: .bottomTrailing) {
                    getDescriptionView()
                }
                
                // Extracted the rating view to a separate method to reduce nesting.
                getRatingView()
                    .padding(.horizontal, 20)
                
                VStack {
                    if let forBid = product.forBid, forBid {
                        getBidButtonView()
                    }
                    HStack {
                        Spacer()
                        
                        // Extracted the bid button view to a separate method to reduce nesting.
                        
                        
                        // Extracted the edit button view to a separate method to reduce nesting.
                        if let userId = userPreferences.getUser()?._id, product.user_id == userId {
                            getEditButtonView()
                        }
                        
                        // Extracted the list/unlist button view to a separate method to reduce nesting.
                        if let userId = userPreferences.getUser()?._id, product.user_id == userId {
                            if let forBid = product.forBid, forBid {
                                Spacer()
                            }
                            getListUnlistButtonView()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                    
                }
            }
            .padding(.horizontal, 20) // add padding to the left and right sides
            .padding(.top, -20)
            .frame(width: min(geometry.size.width, 800)) // limit the card width to 800 points
            .background(Color("card_color"))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .frame(maxWidth: .infinity) // fill the available width
        .padding(.horizontal, -20) // remove the horizontal padding to align with the edges of the screen
        .padding(.top, -20) // remove the top padding to align with the image view
        .background(Color.white.edgesIgnoringSafeArea(.all)) // fill the background with white and ignore the safe area
    }
}

struct FullScreenImageView: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
        } placeholder: {
            ProgressView()
        }
    }
}

struct RatingView: View {
    @Binding var rating: Float
    var maxRating: Int
    var product: ProductModel
    var viewModel: ProductDetailsViewModel
    var body: some View {
        
    
        HStack {
            ForEach(0..<maxRating, id: \.self) { index in
                Button(action: {
                    rating = Float(index + 1)
                    if let productID = product._id {
                        viewModel.addRatingToProduct(productID: productID, rating: rating)
                    }
                }) {
                    Image(systemName: index < Int(rating) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}





