//
//  MainView.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 17/3/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Text("Home Screen")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
            }
            Text("Sellings Screen")
                .tabItem {
                    Image(systemName: "cart.badge.plus")
                    Text("Sellings")
            }
            Text("Search Screen")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
            }
            Text("Notifications Screen")
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
            }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
