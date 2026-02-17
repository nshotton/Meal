import SwiftUI

struct MealDetailView: View {
    @EnvironmentObject private var store: DataStore
    let mealId: UUID
    @State private var showingEdit = false

    private var meal: Meal? { store.meal(id: mealId) }

    var body: some View {
        Group {
            if let meal = meal {
                content(meal: meal)
            }
        }
        .navigationTitle(meal?.name ?? "Meal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") { showingEdit = true }
                    .disabled(meal == nil)
            }
        }
        .sheet(isPresented: $showingEdit) {
            if let meal = meal {
                EditMealView(meal: meal)
            }
        }
    }

    @ViewBuilder
    private func content(meal: Meal) -> some View {
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
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }

            // MARK: Cost Summary
            Section("Cost") {
                HStack {
                    Text("Total Cost")
                    Spacer()
                    Text(meal.totalCost.formatted(.currency(code: "USD")))
                        .fontWeight(.semibold)
                }
                HStack {
                    Text("Per Serving")
                    Spacer()
                    Text(meal.costPerServing.formatted(.currency(code: "USD")))
                        .foregroundColor(.secondary)
                }
            }

            // MARK: Ingredients from receipts
            Section("From Receipts") {
                if meal.mealAllocations.isEmpty {
                    Text("No receipt ingredients yet")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                } else {
                    ForEach(meal.mealAllocations) { alloc in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(alloc.lineItemName)
                                Text(
                                    "\(alloc.fraction.formatted(.percent.precision(.fractionLength(0)))) of "
                                    + alloc.lineItemTotalPrice.formatted(.currency(code: "USD"))
                                )
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(alloc.allocatedCost.formatted(.currency(code: "USD")))
                                .fontWeight(.medium)
                        }
                    }
                }
            }

            // MARK: Ingredients from pantry
            Section("From Pantry") {
                if meal.pantryAllocations.isEmpty {
                    Text("No pantry ingredients yet")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                } else {
                    ForEach(meal.pantryAllocations) { alloc in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(alloc.pantryItemName)
                                if let item = store.pantryItem(id: alloc.pantryItemId) {
                                    Text(
                                        "\(alloc.quantityUsed.formatted(.number.precision(.fractionLength(2)))) \(item.unit)"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Text(alloc.allocatedCost.formatted(.currency(code: "USD")))
                                .fontWeight(.medium)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Edit Sheet

private struct EditMealView: View {
    @EnvironmentObject private var store: DataStore
    @Environment(\.dismiss) private var dismiss

    let meal: Meal
    @State private var name: String
    @State private var emoji: String
    @State private var servings: Int

    private let suggestedEmojis = [
        "🍱", "🥘", "🍲", "🥗", "🍜", "🍝",
        "🍛", "🌮", "🌯", "🥙", "🍔", "🥪",
        "🍳", "🥞", "🍗", "🥩", "🫕", "🫔"
    ]

    init(meal: Meal) {
        self.meal = meal
        _name = State(initialValue: meal.name)
        _emoji = State(initialValue: meal.emoji)
        _servings = State(initialValue: meal.servings)
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Meal Name") {
                    TextField("Meal name", text: $name)
                        .autocorrectionDisabled()
                }

                Section("Emoji") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(suggestedEmojis, id: \.self) { e in
                                Text(e)
                                    .font(.title)
                                    .padding(8)
                                    .background(
                                        emoji == e
                                            ? Color.accentColor.opacity(0.2)
                                            : Color.clear
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture { emoji = e }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Servings") {
                    Stepper(
                        "\(servings) serving\(servings == 1 ? "" : "s")",
                        value: $servings,
                        in: 1...50
                    )
                }
            }
            .navigationTitle("Edit Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func save() {
        var updated = meal
        updated.name = name.trimmingCharacters(in: .whitespaces)
        updated.emoji = emoji
        updated.servings = servings
        store.updateMeal(updated)
        dismiss()
    }
}
