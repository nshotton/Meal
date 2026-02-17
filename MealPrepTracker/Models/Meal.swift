import Foundation
import SwiftData

@Model
final class Meal {
    var id: UUID
    var name: String
    var emoji: String
    var servings: Int
    var createdAt: Date

    @Relationship(deleteRule: .cascade)
    var mealAllocations: [MealAllocation] = []

    @Relationship(deleteRule: .cascade)
    var pantryAllocations: [PantryAllocation] = []

    var totalCost: Double {
        let fromReceipts = mealAllocations.reduce(0.0) { $0 + $1.allocatedCost }
        let fromPantry   = pantryAllocations.reduce(0.0) { $0 + $1.allocatedCost }
        return fromReceipts + fromPantry
    }

    var costPerServing: Double {
        servings > 0 ? totalCost / Double(servings) : 0
    }

    init(
        id: UUID = UUID(),
        name: String,
        emoji: String = "🍱",
        servings: Int = 1,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.servings = servings
        self.createdAt = createdAt
    }
}
