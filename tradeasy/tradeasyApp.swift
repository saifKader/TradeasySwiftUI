//
//  tradeasyApp.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//
import SwiftUI

@main
struct TradeasySwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate	 		
    let persistenceController = PersistenceController.shared
    private var initDI = InitDepedencyInjection()

    @StateObject private var navigationController = NavigationController(startingView: AnyView(SplashView()))

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(navigationController)
                .navigationViewStyle(StackNavigationViewStyle())
        }
        
    }
}



