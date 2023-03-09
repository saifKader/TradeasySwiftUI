//
//  TradeasySwiftUIApp.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 8/3/2023.
//

import SwiftUI
let userRepository = UserRepositoryImpl(dataSource: UserAPIImpl())
let registerUseCase = RegisterUseCase(repo: UserAPIImpl())
let registerViewModel = RegisterViewModel(registerUseCase: registerUseCase)
let registerView = RegisterView(viewModel: registerViewModel)

@main
struct TradeasySwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            registerView
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
