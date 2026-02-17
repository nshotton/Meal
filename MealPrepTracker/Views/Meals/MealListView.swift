import SwiftUI

struct MealListView: View {
    @EnvironmentObject private var store: DataStore
    @State private var showingAddMeal = false

    var body: some View {
        NavigationView {
            Group {
                if store.meals.isEmpty {
                    EmptyStateView(
                        title: "No Meals Yet",
                        systemImage: "fork.knife",
                        description: "Tap + to add your first meal"
                    )
                } else {
                    List {
                        ForEach(store.meals) { meal in
                            NavigationLink(destination: MealDetailView(mealId: meal.id)) {
                                MealRowView(meal: meal)
                            }
                        }
                        .onDelete(perform: store.deleteMeals)
                    }
                }
            }
            .navigationTitle("Meals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAddMeal = true } label: {
                        Image(systemName: "plus")
                    }
                }
                if !store.meals.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView()
            }
        }
        .navigationViewStyle(.stack)
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
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(meal.totalCost.formatted(.currency(code: "USD")))
                    .font(.headline)
                    .foregroundColor(meal.totalCost > 0 ? .primary : .secondary)
                Text(meal.costPerServing.formatted(.currency(code: "USD")) + "/serving")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
