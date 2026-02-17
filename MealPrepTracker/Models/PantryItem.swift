import Foundation

struct PantryItem: Identifiable, Codable {
    var id = UUID()
    var name = ""
    var unit = "count"
    var totalQuantity = 1.0
    var remainingQuantity = 1.0
    var totalCost = 0.0
    var purchaseDate = Date()

    /// Nil when added manually rather than from a scanned receipt.
    var sourceReceiptId: UUID?
    var sourceLineItemId: UUID?

    // MARK: - Computed

    var remainingCost: Double {
        guard totalQuantity > 0 else { return 0 }
        return (remainingQuantity / totalQuantity) * totalCost
    }

    var remainingFraction: Double {
        guard totalQuantity > 0 else { return 0 }
        return remainingQuantity / totalQuantity
    }

    var isEmpty: Bool { remainingQuantity <= 0 }
}
