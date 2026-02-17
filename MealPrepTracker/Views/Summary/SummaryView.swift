import SwiftUI
import SwiftData

struct SummaryView: View {
    @Query private var meals: [Meal]
    @Query private var pantryItems: [PantryItem]

    private var totalSpend: Double {
        meals.reduce(0) { $0 + $1.totalCost }
    }

    private var pantryValue: Double {
        pantryItems.reduce(0) { $0 + $1.remainingCost }
    }

    private var sortedMeals: [Meal] {
        meals.sorted { $0.totalCost > $1.totalCost }
    }

    var body: some View {
        NavigationStack {
            List {
                // MARK: Totals
                Section("Overview") {
                    LabeledContent("Total Tracked Spend") {
                        Text(totalSpend.formatted(.currency(code: "USD")))
                            .fontWeight(.semibold)
                    }
                    LabeledContent("Meals Tracked") {
                        Text("\(meals.count)")
                    }
                    LabeledContent("Pantry Value Remaining") {
                        Text(pantryValue.formatted(.currency(code: "USD")))
                            .foregroundStyle(.green)
                    }
                }

                // MARK: Per-meal breakdown
                if !meals.isEmpty {
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
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(meal.totalCost.formatted(.currency(code: "USD")))
                                        .font(.subheadline.weight(.medium))
                                    Text(meal.costPerServing.formatted(.currency(code: "USD")) + "/serving")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Summary")
            .overlay {
                if meals.isEmpty && pantryItems.isEmpty {
                    ContentUnavailableView(
                        "Nothing to Summarize",
                        systemImage: "chart.bar",
                        description: Text("Add meals and scan receipts to see your spending breakdown")
                    )
                }
            }
        }
    }
}
