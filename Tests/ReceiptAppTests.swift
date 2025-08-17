#if canImport(CoreData)
import XCTest
import CoreData
@testable import ReceiptApp

/// Minimal tests verifying Core Data persistence for receipts.
final class ReceiptAppTests: XCTestCase {
    func testSaveAndFetchReceipt() throws {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        let receipt = Receipt(context: context)
        receipt.id = UUID()
        receipt.imagePath = "test.png"
        receipt.createdAt = Date()
        try context.save()

        let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        let results = try context.fetch(request)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.imagePath, "test.png")
    }
}
#endif
