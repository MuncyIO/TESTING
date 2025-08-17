import Foundation
#if canImport(CoreData)
import CoreData

/// Core Data entity representing a receipt.
@objc(Receipt)
public class Receipt: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var vendor: String?
    @NSManaged public var total: NSDecimalNumber?
    @NSManaged public var date: Date?
    @NSManaged public var tags: [String]?
    @NSManaged public var imagePath: String
    @NSManaged public var createdAt: Date
}

extension Receipt {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }
}
#else
/// Lightweight stand-in model used when CoreData is unavailable (e.g. on Linux).
public struct Receipt: Identifiable {
    public var id: UUID = UUID()
    public var vendor: String? = nil
    public var total: NSDecimalNumber? = nil
    public var date: Date? = nil
    public var tags: [String]? = nil
    public var imagePath: String = ""
    public var createdAt: Date = Date()
}
#endif
