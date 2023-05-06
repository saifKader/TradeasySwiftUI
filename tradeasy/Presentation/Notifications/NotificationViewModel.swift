//
//  HomeViewModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 13/4/2023.
//

import Foundation


enum NotificationHomeListState {
    case idle
    case loading
    case NotificationSuccess([NotificationModel])
    case error(Error)
}

class NotificationViewModel: ObservableObject {
    
    @Published var state: NotificationHomeListState = .idle
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var getNotificationUseCase: NotificationUseCase
    
    init() {
        @Inject var repository: INotificationRepository
        getNotificationUseCase = NotificationUseCase(repo: repository)
    }
    var Notification: [NotificationModel] {
        if case let .NotificationSuccess(Notification) = state {
            return Notification
        }
        return []
    }
    
    func fetchNotifications(completion: @escaping (Result<[NotificationModel], Error>) -> Void) {
        state = .loading
        Task {
            print("Before calling getAllProducts")
            let result = await getNotificationUseCase.fetchNotifications()
            print("After calling getAllProducts")
            
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let categories):
                    print("Product success: \(categories)")
                    self?.state = .NotificationSuccess(categories)
                    completion(.success(categories))
                case .failure(let error):
                    self?.state = .error(error)
                    print("Product error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
}

