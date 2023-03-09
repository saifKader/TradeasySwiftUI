//
//  TradeasySwiftUIApp.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 8/3/2023.
//

import SwiftUI

@main
struct TradeasySwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
