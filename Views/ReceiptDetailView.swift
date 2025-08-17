import SwiftUI
import CoreData

/// Detail editor showing full image and editable fields.
struct ReceiptDetailView: View {
    @ObservedObject var receipt: Receipt
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var tagsText: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = ImageStore.shared.loadImage(from: receipt.imagePath) {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                }
                Form {
                    TextField("Vendor", text: Binding($receipt.vendor, ""))
                    TextField("Total", value: $receipt.total, formatter: NumberFormatter.currency)
                    DatePicker("Date", selection: Binding($receipt.date, Date()), displayedComponents: .date)
                    TextField("Tags", text: $tagsText)
                        .onAppear { tagsText = receipt.tags?.joined(separator: ", ") ?? "" }
                        .onChange(of: tagsText) { newValue in
                            receipt.tags = newValue.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                        }
                }
                .padding()
                HStack {
                    Spacer()
                    Button(role: .destructive) {
                        context.delete(receipt)
                        try? context.save()
                        dismiss()
                    } label: {
                        Text("Delete")
                    }
                }
                .padding(.bottom)
            }
            .padding()
        }
        .background(Color.surface)
        .navigationTitle("Receipt")
        .onDisappear { try? context.save() }
    }
}

/// Helper to bind optional values to text fields.
extension Binding {
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}
