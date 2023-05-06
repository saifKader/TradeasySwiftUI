//
//  BiddersFetchApi.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 5/5/2023.
//

import Foundation

import Alamofire

struct NotificationRepositoryImpl: INotificationRepository {
    let notificationApi: NotificationAPI

        func fetchNotifications()async throws -> [NotificationModel] {
            try await notificationApi.fetchNotifications()
        }
}
