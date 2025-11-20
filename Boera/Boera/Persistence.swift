//
//  Persistence.swift
//  Boera
//
//  Created by Julian Schumacher on 06.05.25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = DrinkEntry(context: viewContext)
            newItem.timestamp = Date()
            newItem.amount = Int16(200 * i)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // Not replaced because this is preview container which is only used in testing and development. fatalError() is ok in this implementation
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Boera")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                BoeraApp.logger.error("Unresolved error when loading persistent store container: \(error), \(error.userInfo)")
                // TODO: return ok?
                return
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        // Core Data Encryption Idea from: https://cocoacasts.com/is-core-data-encrypted
        container.persistentStoreDescriptions.first!.setOption(
            FileProtectionType.complete as NSObject,
            forKey: NSPersistentStoreFileProtectionKey
        )
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.retainsRegisteredObjects = true
        container.viewContext.shouldDeleteInaccessibleFaults = true
    }
}
