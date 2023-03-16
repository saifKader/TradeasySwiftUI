//
//  NavigationManager.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import SwiftUI

class NavigationController: ObservableObject {
    @Published var currentView: AnyView
    @Published var showSheet: Bool = false
    
    init(startingView: AnyView) {
        self.currentView = startingView
    }
    
    func navigate<ViewType: View>(to destination: ViewType) {
        currentView = AnyView(destination)
    }
}
