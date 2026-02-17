import Foundation
import SwiftData

/// Links a specific LineItem (from a receipt) to a Meal, recording what fraction
/// of that item was used and its proportional cost.
@Model
final class MealAllocation {
    var id: UUID
    var fraction: Double       // 0.0–1.0 portion of the line item assigned to this meal
    var allocatedCost: Double  // fraction × lineItem.totalPrice

    var lineItem: LineItem?
    var meal: Meal?

    init(
        id: UUID = UUID(),
        fraction: Double,
        allocatedCost: Double
    ) {
        self.id = id
        self.fraction = fraction
        self.allocatedCost = allocatedCost
    }
}
