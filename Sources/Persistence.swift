import Foundation
#if canImport(CoreData)
import CoreData

/// Handles Core Data stack for the application.
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ReceiptModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /// Saves changes in the view context if needed.
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
}
#else
/// Fallback persistence controller used on platforms without CoreData.
struct PersistenceController {
    static let shared = PersistenceController()
    /// Placeholder container to satisfy cross-platform builds.
    let container: Void? = nil

    init(inMemory: Bool = false) {}

    /// No-op save on non-CoreData platforms.
    func save() {}
}
#endif

