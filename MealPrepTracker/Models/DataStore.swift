import Foundation
import Combine

/// Single source of truth for all app data.
/// Persists to a JSON file in the app's Documents directory.
final class DataStore: ObservableObject {

    @Published var meals: [Meal] = []
    @Published var receipts: [Receipt] = []
    @Published var pantryItems: [PantryItem] = []

    // MARK: - Init / Persistence

    private let saveURL: URL

    init() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        saveURL = docs.appendingPathComponent("mealtracker.json")
        load()
    }

    private struct Store: Codable {
        var meals: [Meal]
        var receipts: [Receipt]
        var pantryItems: [PantryItem]
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(Store(meals: meals, receipts: receipts, pantryItems: pantryItems))
            try data.write(to: saveURL, options: .atomic)
        } catch {
            print("DataStore.save error: \(error)")
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: saveURL),
              let store = try? JSONDecoder().decode(Store.self, from: data) else { return }
        meals = store.meals
        receipts = store.receipts
        pantryItems = store.pantryItems
    }

    // MARK: - Meals

    func addMeal(_ meal: Meal) {
        meals.insert(meal, at: 0)
        save()
    }

    func updateMeal(_ meal: Meal) {
        guard let idx = meals.firstIndex(where: { $0.id == meal.id }) else { return }
        meals[idx] = meal
        save()
    }

    func deleteMeals(at offsets: IndexSet) {
        meals.remove(atOffsets: offsets)
        save()
    }

    // MARK: - Receipts

    func addReceipt(_ receipt: Receipt) {
        receipts.insert(receipt, at: 0)
        save()
    }

    func updateReceipt(_ receipt: Receipt) {
        guard let idx = receipts.firstIndex(where: { $0.id == receipt.id }) else { return }
        receipts[idx] = receipt
        save()
    }

    func deleteReceipts(at offsets: IndexSet) {
        receipts.remove(atOffsets: offsets)
        save()
    }

    // MARK: - Pantry

    func addPantryItem(_ item: PantryItem) {
        pantryItems.append(item)
        save()
    }

    func updatePantryItem(_ item: PantryItem) {
        guard let idx = pantryItems.firstIndex(where: { $0.id == item.id }) else { return }
        pantryItems[idx] = item
        save()
    }

    func deletePantryItem(_ item: PantryItem) {
        pantryItems.removeAll { $0.id == item.id }
        save()
    }

    // MARK: - Allocation: LineItem → Meal + optional Pantry surplus

    /// Assigns `mealFraction` of `lineItemId` to `mealId` and optionally
    /// sends `pantryFraction` to the pantry as a new PantryItem.
    func allocate(
        receiptId: UUID,
        lineItemId: UUID,
        to mealId: UUID,
        mealFraction: Double,
        pantryFraction: Double
    ) {
        guard let rIdx = receipts.firstIndex(where: { $0.id == receiptId }),
              let liIdx = receipts[rIdx].lineItems.firstIndex(where: { $0.id == lineItemId }),
              let mIdx = meals.firstIndex(where: { $0.id == mealId }) else { return }

        let item = receipts[rIdx].lineItems[liIdx]

        // Meal allocation
        if mealFraction > 0 {
            let alloc = MealAllocation(
                receiptId: receiptId,
                lineItemId: lineItemId,
                lineItemName: item.name,
                lineItemTotalPrice: item.totalPrice,
                fraction: mealFraction,
                allocatedCost: item.totalPrice * mealFraction
            )
            meals[mIdx].mealAllocations.append(alloc)
            receipts[rIdx].lineItems[liIdx].allocatedToMealsFraction += mealFraction
        }

        // Pantry surplus
        if pantryFraction > 0 {
            var pantry = PantryItem()
            pantry.name = item.name
            pantry.unit = item.unit
            pantry.totalQuantity = item.quantity
            pantry.remainingQuantity = item.quantity * pantryFraction
            pantry.totalCost = item.totalPrice
            pantry.purchaseDate = receipts[rIdx].date
            pantry.sourceReceiptId = receiptId
            pantry.sourceLineItemId = lineItemId

            receipts[rIdx].lineItems[liIdx].pantryItemId = pantry.id
            receipts[rIdx].lineItems[liIdx].sentToPantryFraction += pantryFraction
            pantryItems.append(pantry)
        }

        save()
    }

    // MARK: - Pantry → Meal usage

    /// Draws `quantityUsed` of `pantryItemId` into `mealId`.
    func usePantryItem(pantryItemId: UUID, for mealId: UUID, quantityUsed: Double) {
        guard let pIdx = pantryItems.firstIndex(where: { $0.id == pantryItemId }),
              let mIdx = meals.firstIndex(where: { $0.id == mealId }) else { return }

        let item = pantryItems[pIdx]
        guard item.totalQuantity > 0 else { return }

        let cost = (quantityUsed / item.totalQuantity) * item.totalCost
        let alloc = PantryAllocation(
            pantryItemId: pantryItemId,
            pantryItemName: item.name,
            quantityUsed: quantityUsed,
            allocatedCost: cost
        )
        meals[mIdx].pantryAllocations.append(alloc)
        pantryItems[pIdx].remainingQuantity = max(0, item.remainingQuantity - quantityUsed)
        save()
    }

    // MARK: - Helpers

    func meal(id: UUID) -> Meal? {
        meals.first { $0.id == id }
    }

    func receipt(id: UUID) -> Receipt? {
        receipts.first { $0.id == id }
    }

    func pantryItem(id: UUID) -> PantryItem? {
        pantryItems.first { $0.id == id }
    }

    /// All pantry allocations across all meals for a given pantry item.
    func allocations(for pantryItemId: UUID) -> [(meal: Meal, allocation: PantryAllocation)] {
        meals.flatMap { meal in
            meal.pantryAllocations
                .filter { $0.pantryItemId == pantryItemId }
                .map { (meal, $0) }
        }
    }
}
