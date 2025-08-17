import Foundation
import CoreData

/// Core Data entity representing a receipt.
@objc(Receipt)
public class Receipt: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
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
