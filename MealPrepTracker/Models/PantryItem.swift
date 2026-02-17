import Foundation
import SwiftData

/// An ingredient stored in the pantry for future use.
/// Created when a LineItem's surplus fraction is sent to the pantry,
/// or manually added for staples not tied to a specific receipt.
@Model
final class PantryItem {
    var id: UUID
    var name: String
    var unit: String             // "jar", "oz", "lbs", "count", etc.

    var totalQuantity: Double    // original full amount (e.g. 1.0 jar)
    var remainingQuantity: Double

    var totalCost: Double        // full original purchase price
    var purchaseDate: Date

    /// Nil when the pantry item was added manually rather than from a receipt.
    var sourceLineItem: LineItem?

    @Relationship(deleteRule: .cascade)
    var pantryAllocations: [PantryAllocation] = []

    // MARK: - Computed

    var remainingCost: Double {
        guard totalQuantity > 0 else { return 0 }
        return (remainingQuantity / totalQuantity) * totalCost
    }

    var remainingFraction: Double {
        guard totalQuantity > 0 else { return 0 }
        return remainingQuantity / totalQuantity
    }

    var isEmpty: Bool {
        remainingQuantity <= 0
    }

    init(
        id: UUID = UUID(),
        name: String,
        unit: String,
        totalQuantity: Double,
        remainingQuantity: Double,
        totalCost: Double,
        purchaseDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.unit = unit
        self.totalQuantity = totalQuantity
        self.remainingQuantity = remainingQuantity
        self.totalCost = totalCost
        self.purchaseDate = purchaseDate
    }
}
