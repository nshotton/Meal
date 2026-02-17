import Foundation

/// Records that a fraction of a specific LineItem was used in a Meal.
/// Name and price are denormalised so the Meal can display them
/// without needing to look up the originating Receipt.
struct MealAllocation: Identifiable, Codable {
    var id = UUID()
    var receiptId: UUID
    var lineItemId: UUID
    var lineItemName: String
    var lineItemTotalPrice: Double
    var fraction: Double        // portion of the line item used (0.0–1.0)
    var allocatedCost: Double   // fraction × lineItemTotalPrice
}
