//
//  INotificationRepository.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 6/5/2023.
//

import Foundation


protocol INotificationRepository {
    func fetchNotifications() async throws -> [NotificationModel]
    
}
