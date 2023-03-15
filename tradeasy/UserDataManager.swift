//
//  UserDataManager.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 15/3/2023.
//
import UIKit
import CoreData

class CoreDataManager {
    

        
        private let context: NSManagedObjectContext
        
        init(context: NSManagedObjectContext) {
            self.context = context
        }
        
    
    // Save a UserModel object to Core Data
    func saveUserToCoreData(userModel: UserModel) {
        let userCore = UserCore(context: context)
        userCore.id = userModel.id
        userCore.username = userModel.username
        userCore.phoneNumber = userModel.phoneNumber
        userCore.email = userModel.email
        userCore.password = userModel.password
        userCore.profilePicture = userModel.profilePicture
        userCore.isVerified = userModel.isVerified ?? false
        userCore.notificationToken = userModel.notificationToken
        userCore.otp = Int32(userModel.otp ?? 0) // Convert optional Int to Int32
        userCore.countryCode = userModel.countryCode
        userCore.token = userModel.token

        // Save the changes to Core Data
        do {
            try context.save()
        } catch let error {
            print("Error saving user to Core Data: \(error.localizedDescription)")
        }
    }
    
    // Fetch all UserCore objects from Core Data
    func fetchAllUsers() -> [UserCore]? {
        let fetchRequest: NSFetchRequest<UserCore> = UserCore.fetchRequest()

        do {
            let users = try context.fetch(fetchRequest)
            return users
        } catch let error {
            print("Error fetching users from Core Data: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Delete a UserCore object from Core Data
    func deleteUserFromCoreData(userCore: UserCore) {
        context.delete(userCore)
        
        // Save the changes to Core Data
        do {
            try context.save()
        } catch let error {
            print("Error deleting user from Core Data: \(error.localizedDescription)")
        }
    }
    
    // Update a UserCore object in Core Data
    func updateUserInCoreData(userCore: UserCore, with userModel: UserModel) {
        userCore.id = userModel.id
        userCore.username = userModel.username
        userCore.phoneNumber = userModel.phoneNumber
        userCore.email = userModel.email
        userCore.password = userModel.password
        userCore.profilePicture = userModel.profilePicture
        userCore.isVerified = userModel.isVerified ?? false
        userCore.notificationToken = userModel.notificationToken
        userCore.otp = Int32(userModel.otp ?? 0) // Convert optional Int to Int32
        userCore.countryCode = userModel.countryCode
        userCore.token = userModel.token
        
        // Save the changes to Core Data
        do {
            try context.save()
        } catch let error {
            print("Error updating user in Core Data: \(error.localizedDescription)")
        }
    }
}