import SwiftUI

struct PantryListView: View {
    @EnvironmentObject private var store: DataStore

    private var sortedItems: [PantryItem] {
        store.pantryItems.sorted { $0.purchaseDate > $1.purchaseDate }
    }
    private var activeItems: [PantryItem] { sortedItems.filter { !$0.isEmpty } }
    private var emptyItems: [PantryItem]  { sortedItems.filter { $0.isEmpty  } }

    var body: some View {
        NavigationView {
            Group {
                if store.pantryItems.isEmpty {
                    EmptyStateView(
                        title: "Pantry is Empty",
                        systemImage: "cabinet",
                        description: "Leftover ingredients will appear here when you allocate a receipt"
                    )
                } else {
                    List {
                        if !activeItems.isEmpty {
                            Section("In Stock") {
                                ForEach(activeItems) { item in
                                    PantryItemRowView(item: item)
                                }
                            }
                        }
                        if !emptyItems.isEmpty {
                            Section("Used Up") {
                                ForEach(emptyItems) { item in
                                    PantryItemRowView(item: item)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pantry")
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Row

struct PantryItemRowView: View {
    let item: PantryItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(item.name)
                    .font(.headline)
                Spacer()
                Text(item.remainingCost.formatted(.currency(code: "USD")))
                    .fontWeight(.medium)
                    .foregroundColor(item.isEmpty ? .secondary : .primary)
            }

            HStack(spacing: 8) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.2))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(barColor)
                            .frame(width: geo.size.width * CGFloat(item.remainingFraction))
                    }
                }
                .frame(height: 6)

                Text(remainingLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize()
            }
        }
        .padding(.vertical, 2)
    }

    private var barColor: Color {
        switch item.remainingFraction {
        case 0:       return .secondary
        case ..<0.25: return .red
        case ..<0.5:  return .orange
        default:      return .green
        }
    }

    private var remainingLabel: String {
        let pct = (item.remainingFraction * 100).rounded()
        return "\(Int(pct))% left"
    }
}
