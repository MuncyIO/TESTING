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
