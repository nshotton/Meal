import Foundation

struct LineItem: Identifiable, Codable {
    var id = UUID()
    var name = ""
    var quantity = 1.0
    var unit = "count"      // e.g. "jar", "lbs", "oz", "count"
    var unitPrice = 0.0
    var totalPrice = 0.0

    /// Cumulative fraction of this item assigned to meals (0.0–1.0).
    var allocatedToMealsFraction = 0.0

    /// Fraction sent to the pantry.
    var sentToPantryFraction = 0.0

    /// ID of the PantryItem created from this item's pantry surplus (if any).
    var pantryItemId: UUID?

    var totalUsedFraction: Double { allocatedToMealsFraction + sentToPantryFraction }
    var remainingFraction: Double  { max(0, 1.0 - totalUsedFraction) }
    var remainingCost: Double      { totalPrice * remainingFraction }
}
