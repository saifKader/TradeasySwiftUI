//
//  SellingView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/4/2023.
//

import SwiftUI

struct SellingView: View {
    @StateObject var viewModel = UserProductsViewModel()
    @State private var showAddProductView = false
    @EnvironmentObject var navigationController: NavigationController
    @State var showLogin = false
    @State var showingAlert = false
  
    var body: some View {
        
        ZStack() {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack(alignment: .center) {
                        
                        
                        Text("Listed Products")
                            .font(Font.custom("Helvetica Neue Bold", size: 26))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.9))
                            .cornerRadius(10)
                        
                        if (viewModel.products.filter { $0.selling! }.isEmpty) {
                            Text("You have no listed products")
                                .foregroundColor(.gray)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(viewModel.products.filter { $0.selling! }, id: \._id) { product in
                                        Button(action: {
                                            withAnimation {
                                                navigationController.navigateAnimation(to: ProductDetailsView(product: product), type: .productDetailsView)
                                            }
                                        }) {
                                            ProductRowView(product: product)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 20)
                            }
                        }
                    }
                    
                    // Products Forbid
                    VStack(alignment: .center) {
                        
                        Text("Unlisted Products")
                            .font(Font.custom("Helvetica Neue Bold", size: 26))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.gray)
                            .cornerRadius(10)
                        
                        if (viewModel.products.filter { !$0.selling! }.isEmpty) {
                            Text("You have no unlisted products")
                                .foregroundColor(.gray)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(viewModel.products.filter { !$0.selling! }, id: \._id) { product in
                                        Button(action: {
                                            withAnimation {
                                                navigationController.navigateAnimation(to: ProductDetailsView(product: product), type: .productDetailsView)
                                            }
                                        }) {
                                            ProductRowView(product: product)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 20)
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.loadUserProducts()
                }
                .onAppear {
                    viewModel.loadUserProducts()
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton(onClick: {
                        showingAlert = true
                    })
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .onAppear {
            
            // Perform your action here
            if userPreferences.getUser() == nil
            {
                showLogin = true
                navigationController.navigate(to: LoginView())
            }
        }
    }
}
/*.navigationBarItems(
 leading: Button(action: {
     navigationController.popToRoot()
 }) {
     Image(systemName: "xmark")
         .foregroundColor(Color("black_white"))
 }
)*/

struct FloatingActionButton: View {
    let onClick: () -> Void
    @State var showLogin = false
    @State var showAddProduct = false
    @State var showingAlert = false
    @State var showVerificationSheet = false
    let userPreferences = UserPreferences()
    @StateObject var smsViewModel = SendVerificationSmsViewModel()
    @EnvironmentObject var navigationController: NavigationController
    var body: some View {
        if !(userPreferences.getUser()?.isVerified ?? false) {
            Button(action: {
                showingAlert.toggle() // Show alert
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color("app_color"))
                        .frame(width: 60, height: 60)
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.white)
                }
            }
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Verify your account"),
                    message: Text("You need to verify your account to start selling"),
                    primaryButton: .default(Text("OK")) {
                        showVerificationSheet = true
                        smsViewModel.sendVerificationSms(){ result in
                            switch result {
                            case .success:
                                smsViewModel.state = .success
                                DispatchQueue.main.async {
                                    navigationController.popToRoot()
                                    
                                }
                                
                            case .failure(let error):
                                if case let UseCaseError.error(message) = error {
                                 
                                    print("Error resetting password: \(message)")
                                } else {
                                    print("Error resetting password: \(error)")
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showVerificationSheet) { // Present the verification view as a sheet
                OTPVerificationAccount()
                        }
        } else {
            Button(action: {
                   navigationController.navigate(to: AddProductView())
               }) {
                   ZStack {
                       Circle()
                           .foregroundColor(Color("app_color"))
                           .frame(width: 60, height: 60)
                       Image(systemName: "plus")
                           .resizable()
                           .frame(width: 24, height: 24)
                           .foregroundColor(Color.white)
                   }
               }
               .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
        }
    }
}


