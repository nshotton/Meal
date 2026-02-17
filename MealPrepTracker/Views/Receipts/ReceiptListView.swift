import SwiftUI
import SwiftData

struct ReceiptListView: View {
    @Query(sort: \Receipt.date, order: .reverse) private var receipts: [Receipt]
    @State private var showingScanner = false

    var body: some View {
        NavigationStack {
            Group {
                if receipts.isEmpty {
                    ContentUnavailableView(
                        "No Receipts Yet",
                        systemImage: "doc.text.viewfinder",
                        description: Text("Tap + to scan your first grocery receipt")
                    )
                } else {
                    List(receipts) { receipt in
                        ReceiptRowView(receipt: receipt)
                    }
                }
            }
            .navigationTitle("Receipts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingScanner = true } label: {
                        Image(systemName: "plus")
                    }
                    // Scanner not yet implemented — enabled in a future step
                    .disabled(true)
                }
            }
        }
    }
}

// MARK: - Row

private struct ReceiptRowView: View {
    let receipt: Receipt

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(receipt.storeName.isEmpty ? "Unknown Store" : receipt.storeName)
                .font(.headline)
            HStack {
                Text(receipt.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(receipt.totalAmount.formatted(.currency(code: "USD")))
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .padding(.vertical, 2)
    }
}
