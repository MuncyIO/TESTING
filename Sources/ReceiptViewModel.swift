#if canImport(SwiftUI) && canImport(CoreData) && canImport(Quartz)
import SwiftUI
import CoreData
import Combine
import AppKit

/// View model driving receipt operations such as importing and deleting.
final class ReceiptViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private let imageStore: ImageStore
    private let ocrService = OCRService()

    init(context: NSManagedObjectContext, imageStore: ImageStore = .shared) {
        self.context = context
        self.imageStore = imageStore
    }

    /// Opens a file picker to import an image as a receipt.
    func addReceipt() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = NSImage.imageTypes
        panel.begin { response in
            guard response == .OK, let url = panel.url,
                  let image = NSImage(contentsOf: url) else { return }
            self.handleImport(image: image)
        }
    }

    /// Saves image and creates a new Receipt record, running OCR to pre-fill metadata.
    private func handleImport(image: NSImage) {
        let imageName: String
        do {
            imageName = try imageStore.saveImage(image)
        } catch {
            print("Failed to save image: \(error)")
            return
        }
        let receipt = Receipt(context: context)
        receipt.id = UUID()
        receipt.imagePath = imageName
        receipt.createdAt = Date()
        receipt.vendor = ""
        ocrService.extract(from: image) { result in
            receipt.vendor = result.vendor ?? receipt.vendor
            receipt.total = result.total as NSDecimalNumber?
            receipt.date = result.date
            try? self.context.save()
        }
    }

    /// Deletes a receipt from storage.
    func delete(_ receipt: Receipt) {
        context.delete(receipt)
        try? context.save()
    }
}
#endif
