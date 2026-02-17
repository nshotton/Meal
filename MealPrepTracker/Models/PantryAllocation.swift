import Foundation
import SwiftData

/// Records when a pantry item is drawn upon for a specific meal.
/// Decrements the PantryItem's remainingQuantity and charges the
/// proportional cost to the meal.
@Model
final class PantryAllocation {
    var id: UUID
    var quantityUsed: Double   // absolute amount consumed (in item's unit)
    var allocatedCost: Double  // (quantityUsed / pantryItem.totalQuantity) × pantryItem.totalCost
    var date: Date

    var pantryItem: PantryItem?
    var meal: Meal?

    init(
        id: UUID = UUID(),
        quantityUsed: Double,
        allocatedCost: Double,
        date: Date = Date()
    ) {
        self.id = id
        self.quantityUsed = quantityUsed
        self.allocatedCost = allocatedCost
        self.date = date
    }
}
