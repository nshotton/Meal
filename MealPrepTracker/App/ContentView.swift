import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ReceiptListView()
                .tabItem {
                    Label("Receipts", systemImage: "doc.text.viewfinder")
                }

            MealListView()
                .tabItem {
                    Label("Meals", systemImage: "fork.knife")
                }

            PantryListView()
                .tabItem {
                    Label("Pantry", systemImage: "cabinet")
                }

            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "chart.bar.fill")
                }
        }
    }
}
