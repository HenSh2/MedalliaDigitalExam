//
//  CDService.swift
//  MedalliaDigitalExam
//
//  Created by Hen Shabat on 03/06/2019.
//  Copyright © 2019 Hen Shabat. All rights reserved.
//

import Foundation
import CoreData

class CDService {
    
    private init() {}
    
    static private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    static private var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MedalliaDigitalExam")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func saveActions(_ actions: [MedalliaAction]) {
        CDService.resetActions()
        for action in actions {
            self.changeToCDModel(action)
            CDService.saveContext()
        }
    }
    
    private static func resetActions() {
        for action in CDService.actions() {
            CDService.context.delete(action)
        }
        CDService.saveContext()
    }
    
    static func actions() -> [CDAction] {
        do {
            let actionsAny = try CDService.persistentContainer.viewContext.fetch(CDAction.fetchRequest())
            var actions: [CDAction] = [CDAction]()
            for action in actionsAny {
                if let act = action as? CDAction {
                    actions.append(act)
                }
            }
            CDService.saveContext()
            return actions
        } catch {
            print("Fetch action failed")
        }
        return [CDAction]()
    }
    
    static func updateTrigger(_ action: CDAction) {
        action.triggeredAt = Date()
        CDService.saveContext()
    }
    
    @discardableResult private static func changeToCDModel(_ action: MedalliaAction) -> CDAction {
        let act = CDAction(context: CDService.context)
        act.type = action.type.rawValue
        act.enabled = action.enabled
        act.title = action.title
        act.body = action.body
        act.priority = Int16(action.priority)
        act.validDays = action.validDays.map { $0.rawValue }
        act.coolDown = Int64(action.coolDown)
        return act
    }
    
}
