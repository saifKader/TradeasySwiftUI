//
//  ContentView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var navigationController: NavigationController
    @ObservedObject var userPreferences = UserPreferences()
    @ObservedObject var productPreferences = ProductPreferences()
    
    var body: some View {
            NavigationView {
                navigationController.currentView
            }
            .environmentObject(userPreferences)
            .environmentObject(productPreferences)
        }
    }


