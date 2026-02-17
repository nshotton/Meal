import Foundation
import SwiftData

@Model
final class LineItem {
    var id: UUID
    var name: String
    var quantity: Double
    var unit: String          // e.g. "jar", "lbs", "oz", "count"
    var unitPrice: Double
    var totalPrice: Double

    var receipt: Receipt?

    @Relationship(deleteRule: .cascade)
    var mealAllocations: [MealAllocation] = []

    // The PantryItem created when this line item's surplus is sent to the pantry.
    // deleteRule .nullify means if this LineItem is deleted, the PantryItem
    // remains but its sourceLineItem is set to nil.
    @Relationship(deleteRule: .nullify)
    var pantryContribution: PantryItem?

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Double = 1,
        unit: String = "count",
        unitPrice: Double,
        totalPrice: Double
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
    }
}
