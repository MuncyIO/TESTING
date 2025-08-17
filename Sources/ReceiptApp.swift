import Foundation
#if canImport(SwiftUI) && canImport(CoreData)
import SwiftUI

@main
struct ReceiptApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ReceiptListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .accentColor(.accentPrimary)
                .preferredColorScheme(.dark)
        }
    }
}
#else
/// Placeholder main entry point for platforms without SwiftUI/CoreData.
@main
struct ReceiptApp {
    static func main() {
        // Application UI isn't supported on this platform.
        print("ReceiptApp cannot run on this platform.")
    }
}
#endif
