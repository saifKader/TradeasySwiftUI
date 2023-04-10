//
//  MainView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 17/3/2023.
//

import SwiftUI
let userPreferences = UserPreferences()
struct MainView: View {
    @State  var isLoginShown: Bool = userPreferences.getUser() == nil
    @State private var selectedTab = 0
    @ViewBuilder

    
    
    var body: some View {
        NavigationStack{
            TabView(selection: $selectedTab) {
                
               // FirebaseRegisterView(email: "")
                SearchView()
                
                           .tabItem {
                               TabIcon(selected: $selectedTab, index: 0) {
                                   Label("Home", systemImage: "house")
                               }
                           }.tag(0)

                       Text("Sellings Screen")
                           .tabItem {
                               TabIcon(selected: $selectedTab, index: 1) {
                                   Label("Sellings", systemImage: "cart.badge.plus")
                               }
                           }.tag(1)

                SearchView()
                           .tabItem {
                               TabIcon(selected: $selectedTab, index: 2) {
                                   Label("Search", systemImage: "magnifyingglass")
                               }
                           }.tag(2)

                       Text("Notifications Screen")
                           .tabItem {
                               TabIcon(selected: $selectedTab, index: 3) {
                                   Label("Notifications", systemImage: "bell")
                               }
                           }.tag(3)

                       ProfileView()
                           .tabItem {
                               TabIcon(selected: $selectedTab, index: 4) {
                                   Label("Profile", systemImage: "person")
                               }
                           }.tag(4)
                   }.accentColor(Color("app_color"))
        }
    }
}


struct TabIcon<Content: View>: View {
    @Binding var selected: Int
    let index: Int
    let content: Content

    init(selected: Binding<Int>, index: Int, @ViewBuilder content: () -> Content) {
        self._selected = selected
        self.index = index
        self.content = content()
    }

    var body: some View {
        Group {
            if selected == index {
                content
            } else {
                content
                    .environment(\.symbolVariants, .none)
            }
        }
    }
}
