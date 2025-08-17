#if canImport(AppKit)
import Foundation
import AppKit

/// Handles saving and loading receipt images on disk.
final class ImageStore {
    static let shared = ImageStore()

    private let directory: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleId = Bundle.main.bundleIdentifier ?? "ReceiptApp"
        directory = appSupport.appendingPathComponent(bundleId).appendingPathComponent("Receipts")
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    /// Saves an image and returns the relative filename.
    func saveImage(_ image: NSImage) throws -> String {
        let name = UUID().uuidString + ".png"
        let url = directory.appendingPathComponent(name)
        guard let data = image.pngData else {
            throw NSError(domain: "ImageStore", code: 0, userInfo: [NSLocalizedDescriptionKey: "PNG conversion failed"])
        }
        try data.write(to: url)
        return name
    }

    /// Loads an image at the given relative path.
    func loadImage(from path: String) -> NSImage? {
        let url = directory.appendingPathComponent(path)
        return NSImage(contentsOf: url)
    }
}

extension NSImage {
    /// Returns PNG data for the image if possible.
    var pngData: Data? {
        guard let tiff = tiffRepresentation, let rep = NSBitmapImageRep(data: tiff) else { return nil }
        return rep.representation(using: .png, properties: [:])
    }
}
#endif
