//
//  DatabaseManager.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation
import UIKit
import CoreData

class DatapersistenceManager {
    
    enum DatabaseError : Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
        case invalidAppDelegate
    }
    
    
    static let shared = DatapersistenceManager()
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveUser(model: InternalUserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let item = UserInfo(context: context)
        
        item.serviceNumber = model.serviceNumber
        item.consumptionPrice = model.lastConsumption
        item.consumptions = model.consumptions as NSArray
        item.calculatedConsumption = model.calculatedCost
        
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
            print(error.localizedDescription)
        }
    }
    
    func fetchUsers() -> [UserInfo] {
        var users: [UserInfo] = []
        
        do{
            users = try context.fetch(UserInfo.fetchRequest())
        }catch {
            print("will be logged Fetch User error", error)
        }
        print(users)
        return users
    }
    
//    private func addUpdateUser(userEntity: UserEntity, user: UserModel) {
//            userEntity.firstName = user.firstName
//            userEntity.lastName = user.lastName
//            userEntity.email = user.email
//            userEntity.password = user.password
//            userEntity.imageName = user.imageName
//            saveContext()
//        }

    func fetchUserModel(withServiceNumber serviceNumber: String, completion: @escaping (Result<UserInfo?, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(DatabaseError.invalidAppDelegate))
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        request.predicate = NSPredicate(format: "serviceNumber == %@", serviceNumber)
        
        do {
            let results = try context.fetch(request)
            let userInfo = results.first
            completion(.success(userInfo))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
   
    








    
//    func fetchUserModel(withID id: String, completion: @escaping (Result<UserInfo?, Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//
//        let managedObject = // ... an NSManagedObject
//        let managedObjectID = managedObject.objectID
//
//        // Get a reference to a NSManagedObjectContext
//        let context = persistentContainer.viewContext
//
//        // Get the object by ID from the NSManagedObjectContext
//        let object = try context.existingObject(
//            with: managedObjectID
//        )
//
//        let context = appDelegate.persistentContainer.viewContext
//        let request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
//        request.predicate = NSPredicate(format: "serviceNumber == %@", id)
//
//        do {
//            let results = try context.fetch(request)
//            let userModel = results.first
//            completion(.success(userModel))
//        } catch {
//            completion(.failure(DatabaseError.failedToFetchData))
//        }
//    }
}
