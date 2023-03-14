//
//  DepedencyInjector.swift
//  TradeasySwiftUI
//
//  Created by abdelkader seif eddine on 14/3/2023.
//

import Foundation
import Foundation

struct DepedencyInjector {
    private static var depedencyList: [String:Any] = [:]
    
    static func resolve<T>() -> T {
        guard let t = depedencyList[String(describing: T.self)] as? T else{
            fatalError("No provider registered for type: \(T.self)")
        }
        return t
    }
    
    static func register<T>(depedency: T){
        depedencyList[String(describing:  T.self)] = depedency
    }
}

@propertyWrapper struct Inject<T> {
    var wrappedValue: T
    
    init(){
        self.wrappedValue = DepedencyInjector.resolve()
        print("Injected <-", self.wrappedValue)
    }
}

@propertyWrapper struct Provider<T> {
    var wrappedValue: T
    
    init(wrappedValue: T){
        self.wrappedValue = wrappedValue
        DepedencyInjector.register(depedency: wrappedValue)
        print("Provided ->", self.wrappedValue)
    }
}
