//
//  NavigationManager.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//

import SwiftUI
enum NavigationViewType {
    case mainView
    case productDetailsView
    // Add other view types here as necessary.
}

class NavigationController: ObservableObject {
    @Published var currentView: AnyView
    @Published var currentViewType: NavigationViewType
    @Published var currentTab: Int
    private var viewStack: [(view: AnyView, type: NavigationViewType)] = []
    
    
    @Published var isUpdateEmailPresent: Bool = false
    @Published var isotp: Bool = false
    var navigationController: UINavigationController?
    
    init(startingView: AnyView, startingViewType: NavigationViewType, startingTab: Int = 0) {
          self.currentView = startingView
          self.currentViewType = startingViewType
          self.currentTab = startingTab
      }
    
    func navigate<ViewType: View>(to destination: ViewType) {
           viewStack.append((currentView, currentViewType))
           currentView = AnyView(destination)
           
       }
    func navigateAnimation<ViewType: View>(to destination: ViewType, type: NavigationViewType) {
           viewStack.append((currentView, currentViewType))
           currentView = AnyView(destination)
           currentViewType = type
       }
    func navigateWithArgs<ViewType: View, Args>(to destination: @escaping (Args) -> ViewType, args: Args) {
        viewStack.append((currentView, currentViewType))
        currentView = AnyView(destination(args))
    }

    func removeAllViews() {
        viewStack.removeAll()
    }
    
    func popToRoot() {
           if let first = viewStack.first {
               currentView = first.view
               currentViewType = first.type
               viewStack.removeAll()
           }
       }
   }
