import SwiftUI

struct ReceiptListView: View {
    @EnvironmentObject private var store: DataStore
    @State private var showingScanner = false

    var body: some View {
        NavigationView {
            Group {
                if store.receipts.isEmpty {
                    EmptyStateView(
                        title: "No Receipts Yet",
                        systemImage: "doc.text.viewfinder",
                        description: "Tap + to scan your first grocery receipt"
                    )
                } else {
                    List {
                        ForEach(store.receipts) { receipt in
                            ReceiptRowView(receipt: receipt)
                        }
                        .onDelete(perform: store.deleteReceipts)
                    }
                }
            }
            .navigationTitle("Receipts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingScanner = true } label: {
                        Image(systemName: "plus")
                    }
                    // Scanner implemented in next step
                    .disabled(true)
                }
            }
        }
        .navigationViewStyle(.stack)
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
                    .foregroundColor(.secondary)
                Spacer()
                Text(receipt.totalAmount.formatted(.currency(code: "USD")))
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .padding(.vertical, 2)
    }
}
