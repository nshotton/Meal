import SwiftUI
import SwiftData

struct MealDetailView: View {
    @Bindable var meal: Meal
    @State private var showingEdit = false

    var body: some View {
        List {
            // MARK: Header
            Section {
                HStack(spacing: 16) {
                    Text(meal.emoji)
                        .font(.system(size: 56))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(meal.name)
                            .font(.title2.bold())
                        Text("\(meal.servings) serving\(meal.servings == 1 ? "" : "s")")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }

            // MARK: Cost Summary
            Section("Cost") {
                LabeledContent("Total Cost") {
                    Text(meal.totalCost.formatted(.currency(code: "USD")))
                        .fontWeight(.semibold)
                }
                LabeledContent("Per Serving") {
                    Text(meal.costPerServing.formatted(.currency(code: "USD")))
                        .foregroundStyle(.secondary)
                }
            }

            // MARK: Ingredients from receipts
            Section {
                if meal.mealAllocations.isEmpty {
                    Text("No receipt ingredients yet")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                } else {
                    ForEach(meal.mealAllocations) { allocation in
                        if let item = allocation.lineItem {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                    Text("\(allocation.fraction.formatted(.percent)) of \(item.totalPrice.formatted(.currency(code: "USD")))")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(allocation.allocatedCost.formatted(.currency(code: "USD")))
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }
            } header: {
                Text("From Receipts")
            }

            // MARK: Ingredients from pantry
            Section {
                if meal.pantryAllocations.isEmpty {
                    Text("No pantry ingredients yet")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                } else {
                    ForEach(meal.pantryAllocations) { allocation in
                        if let item = allocation.pantryItem {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                    Text("\(allocation.quantityUsed.formatted(.number.precision(.fractionLength(2)))) \(item.unit)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(allocation.allocatedCost.formatted(.currency(code: "USD")))
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }
            } header: {
                Text("From Pantry")
            }
        }
        .navigationTitle(meal.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showingEdit = true }
            }
        }
        .sheet(isPresented: $showingEdit) {
            EditMealView(meal: meal)
        }
    }
}

// MARK: - Edit Sheet

private struct EditMealView: View {
    @Bindable var meal: Meal
    @Environment(\.dismiss) private var dismiss

    private let suggestedEmojis = [
        "🍱", "🥘", "🍲", "🥗", "🍜", "🍝",
        "🍛", "🌮", "🌯", "🥙", "🍔", "🥪",
        "🍳", "🥞", "🍗", "🥩", "🫕", "🫔"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Meal Name") {
                    TextField("Meal name", text: $meal.name)
                        .autocorrectionDisabled()
                }

                Section("Emoji") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(suggestedEmojis, id: \.self) { emoji in
                                Text(emoji)
                                    .font(.title)
                                    .padding(8)
                                    .background(
                                        meal.emoji == emoji
                                            ? Color.accentColor.opacity(0.2)
                                            : Color.clear
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture { meal.emoji = emoji }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Servings") {
                    Stepper(
                        "\(meal.servings) serving\(meal.servings == 1 ? "" : "s")",
                        value: $meal.servings,
                        in: 1...50
                    )
                }
            }
            .navigationTitle("Edit Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
