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
    @Published var isUpdateEmailPresent: Bool = false
    @Published var isotp: Bool = false
    var navigationController: UINavigationController?
    
    init(startingView: AnyView) {
        self.currentView = startingView
    }
    
    func navigate<ViewType: View>(to destination: ViewType) {
        viewStack.append(currentView)
        currentView = AnyView(destination)
    }
    
    func navigateWithArgs<ViewType: View, Args>(to destination: @escaping (Args) -> ViewType, args: Args) {
        viewStack.append(currentView)
        currentView = AnyView(destination(args))
    }

    func removeAllViews() {
        viewStack.removeAll()
    }
    
    func popToRoot() {
            if viewStack.count > 0 {
                currentView = viewStack.first!
                viewStack.removeAll()
            }
        }
}

