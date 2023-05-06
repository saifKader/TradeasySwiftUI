// BidderUseCase.swift
// tradeasy
//
// Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation



protocol INotification {
    func fetchNotifications() async -> Result<[NotificationModel], UseCaseError>
}
struct NotificationUseCase:  INotification {
    
    
    var repo: INotificationRepository

    func fetchNotifications() async -> Result<[NotificationModel], UseCaseError> {
        do {
            let notifications = try await repo.fetchNotifications()
            return .success(notifications)
        } catch let error as APIServiceError {
            switch error {
            case .statusNotOK(let message):
                return .failure(.error(message: message))
            default:
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
}
