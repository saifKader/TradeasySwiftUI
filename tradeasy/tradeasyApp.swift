//
//  tradeasyApp.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//
import SwiftUI

@main
struct TradeasySwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    private var initDI = InitDepedencyInjection()

    @StateObject private var navigationController = NavigationController(startingView: AnyView(LoginView()))

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationController)
        }
    }
}



