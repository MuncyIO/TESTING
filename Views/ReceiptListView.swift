import SwiftUI
import CoreData

/// Displays receipts in a scrolling list with ability to add new ones.
struct ReceiptListView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: ReceiptViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Receipt.createdAt, ascending: false)],
        animation: .default)
    private var receipts: FetchedResults<Receipt>

    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: ReceiptViewModel(context: context))
        _receipts = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Receipt.createdAt, ascending: false)],
            animation: .default)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(receipts) { receipt in
                    NavigationLink(destination: ReceiptDetailView(receipt: receipt)) {
                        ReceiptRowView(receipt: receipt)
                    }
                }
                .onDelete(perform: delete)
            }
            .listStyle(.inset)
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: viewModel.addReceipt) {
                        Image(systemName: "plus")
                    }
                    .help("Add Receipt")
                }
            }
        }
    }

    private func delete(offsets: IndexSet) {
        offsets.map { receipts[$0] }.forEach(viewModel.delete)
    }
}

/// Row representing a single receipt.
struct ReceiptRowView: View {
    @ObservedObject var receipt: Receipt

    var body: some View {
        HStack {
            if let image = ImageStore.shared.loadImage(from: receipt.imagePath) {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .cornerRadius(4)
            }
            VStack(alignment: .leading) {
                Text(receipt.vendor?.isEmpty == false ? receipt.vendor! : receipt.imagePath)
                    .foregroundColor(.textPrimary)
                if let date = receipt.date {
                    Text(date, style: .date)
                        .foregroundColor(.textMuted)
                        .font(.caption)
                }
            }
            Spacer()
            if let total = receipt.total {
                Text(NumberFormatter.currency.string(from: total) ?? "")
                    .foregroundColor(.textPrimary)
            }
        }
        .padding(.vertical, 4)
    }
}

extension NumberFormatter {
    static let currency: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        return nf
    }()
}
