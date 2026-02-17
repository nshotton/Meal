import SwiftUI
import SwiftData

@main
struct MealPrepTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Receipt.self,
            LineItem.self,
            Meal.self,
            MealAllocation.self,
            PantryItem.self,
            PantryAllocation.self
        ])
    }
}
