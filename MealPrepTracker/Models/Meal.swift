import Foundation

struct Meal: Identifiable, Codable {
    var id = UUID()
    var name = ""
    var emoji = "🍱"
    var servings = 1
    var createdAt = Date()
    var mealAllocations: [MealAllocation] = []
    var pantryAllocations: [PantryAllocation] = []

    var totalCost: Double {
        mealAllocations.reduce(0) { $0 + $1.allocatedCost } +
        pantryAllocations.reduce(0) { $0 + $1.allocatedCost }
    }

    var costPerServing: Double {
        servings > 0 ? totalCost / Double(servings) : 0
    }
}
