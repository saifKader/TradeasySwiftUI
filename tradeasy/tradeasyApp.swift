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

    @StateObject private var navigationController = NavigationController(startingView: AnyView(MainView()), startingViewType: .productDetailsView, startingTab: 0)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(navigationController)
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear {
                    navigationController.currentTab = 0
                }
        }
    }
}



