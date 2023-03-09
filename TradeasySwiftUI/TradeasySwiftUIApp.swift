//
//  TradeasySwiftUIApp.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 8/3/2023.
//

import SwiftUI

@main
struct TradeasySwiftUIApp: App {
    let registerUseCase = RegisterUseCase(repo: UserRepositoryImpl(dataSource: UserAPIImpl()))
    let registerViewModel = RegisterViewModel(registerUseCase: registerUseCase)
    
    var body: some Scene {
        WindowGroup {
            RegisterView(viewModel: registerViewModel)
        }
    }
}

