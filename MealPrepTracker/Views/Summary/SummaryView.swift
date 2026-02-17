import SwiftUI

struct SummaryView: View {
    @EnvironmentObject private var store: DataStore

    private var totalSpend: Double {
        store.meals.reduce(0) { $0 + $1.totalCost }
    }

    private var pantryValue: Double {
        store.pantryItems.reduce(0) { $0 + $1.remainingCost }
    }

    private var sortedMeals: [Meal] {
        store.meals.sorted { $0.totalCost > $1.totalCost }
    }

    var body: some View {
        NavigationView {
            Group {
                if store.meals.isEmpty && store.pantryItems.isEmpty {
                    EmptyStateView(
                        title: "Nothing to Summarize",
                        systemImage: "chart.bar",
                        description: "Add meals and scan receipts to see your spending breakdown"
                    )
                } else {
                    List {
                        Section("Overview") {
                            HStack {
                                Text("Total Tracked Spend")
                                Spacer()
                                Text(totalSpend.formatted(.currency(code: "USD")))
                                    .fontWeight(.semibold)
                            }
                            HStack {
                                Text("Meals Tracked")
                                Spacer()
                                Text("\(store.meals.count)")
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Text("Pantry Value Remaining")
                                Spacer()
                                Text(pantryValue.formatted(.currency(code: "USD")))
                                    .foregroundColor(.green)
                            }
                        }

                        if !store.meals.isEmpty {
                            Section("By Meal") {
                                ForEach(sortedMeals) { meal in
                                    HStack(spacing: 12) {
                                        Text(meal.emoji)
                                            .font(.title3)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(meal.name)
                                                .font(.subheadline.weight(.medium))
                                            Text("\(meal.servings) serving\(meal.servings == 1 ? "" : "s")")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text(meal.totalCost.formatted(.currency(code: "USD")))
                                                .font(.subheadline.weight(.medium))
                                            Text(meal.costPerServing.formatted(.currency(code: "USD")) + "/serving")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Summary")
        }
        .navigationViewStyle(.stack)
    }
}
