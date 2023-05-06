

import SwiftUI
import CoreData
@objc(NotificationEntity)
public class NotificationEntity: NSManagedObject {

}

extension NotificationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationEntity> {
        return NSFetchRequest<NotificationEntity>(entityName: "CDNotification")
    }

    @NSManaged public var title: String?
    @NSManaged public var nDescription: String?
    @NSManaged public var date: Int64
    @NSManaged public var id: String?
    // Change the type here to Int64

}

@MainActor
func fetchNotificationsFromCoreData(context: NSManagedObjectContext, completion: @escaping (Result<[NotificationModel], Error>) -> Void) {
    let request: NSFetchRequest<CDNotification> = CDNotification.fetchRequest()
    
    do {
        let notificationEntities = try context.fetch(request)
        
        // Create an empty list of NotificationModel
        var notificationModels: [NotificationModel] = []
        
        // Fill the list with the fetched results
        for entity in notificationEntities {
       
            let notificationModel = NotificationModel(id: entity.id!, title: entity.title!, description: entity.nDescription!, date: Int(entity.date))
            notificationModels.append(notificationModel)

        }
        
        completion(.success(notificationModels))
    } catch {
        completion(.failure(error))
    }
}
