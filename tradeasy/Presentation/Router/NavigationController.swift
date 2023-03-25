//
//  NavigationManager.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import SwiftUI

class NavigationController: ObservableObject {
    @Published var currentView: AnyView
    private var viewStack: [AnyView] = []
    @Published var navigateToLoggin: Bool = false
    init(startingView: AnyView) {
        self.currentView = startingView
    }
    
    func navigate<ViewType: View>(to destination: ViewType) {
        viewStack.append(currentView)
        currentView = AnyView(destination)
    }
    func removeAllViews() {
        viewStack.removeAll()
    }
    //navigation stacked
    func pop() {
        if viewStack.count > 0 {
            currentView = viewStack.removeLast()
        }
    }
    //remove all navigationlink and go to the first view
    func popToRoot() {
        if viewStack.count > 0 {
            currentView = viewStack.first!
            viewStack.removeAll()
        }
    }
    func navigateBack() {
            self.navigateToLoggin = false
        }
}
