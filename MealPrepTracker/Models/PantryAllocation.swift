import Foundation

/// Records that a quantity of a PantryItem was used in a Meal.
/// Stored inside Meal.pantryAllocations; PantryItem.remainingQuantity
/// is decremented separately when an allocation is made.
struct PantryAllocation: Identifiable, Codable {
    var id = UUID()
    var pantryItemId: UUID
    var pantryItemName: String   // denormalised for display
    var quantityUsed: Double
    var allocatedCost: Double
    var date = Date()
}
