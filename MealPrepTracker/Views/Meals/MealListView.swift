import SwiftUI
import SwiftData

struct MealListView: View {
    @Query(sort: \Meal.createdAt, order: .reverse) private var meals: [Meal]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddMeal = false

    var body: some View {
        NavigationStack {
            Group {
                if meals.isEmpty {
                    ContentUnavailableView(
                        "No Meals Yet",
                        systemImage: "fork.knife",
                        description: Text("Tap + to add your first meal")
                    )
                } else {
                    List {
                        ForEach(meals) { meal in
                            NavigationLink(destination: MealDetailView(meal: meal)) {
                                MealRowView(meal: meal)
                            }
                        }
                        .onDelete(perform: deleteMeals)
                    }
                }
            }
            .navigationTitle("Meals")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddMeal = true } label: {
                        Image(systemName: "plus")
                    }
                }
                if !meals.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView()
            }
        }
    }

    private func deleteMeals(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(meals[index])
        }
    }
}

// MARK: - Row

private struct MealRowView: View {
    let meal: Meal

    var body: some View {
        HStack(spacing: 12) {
            Text(meal.emoji)
                .font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text(meal.name)
                    .font(.headline)
                Text("\(meal.servings) serving\(meal.servings == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(meal.totalCost.formatted(.currency(code: "USD")))
                    .font(.headline)
                    .foregroundStyle(meal.totalCost > 0 ? .primary : .secondary)
                Text(meal.costPerServing.formatted(.currency(code: "USD")) + "/serving")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
