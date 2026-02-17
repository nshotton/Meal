# Meal Prep Cost Tracker — iOS App Implementation Plan

## Overview
An iOS app that lets users photograph grocery receipts, assign ingredients to specific meals,
and automatically calculates per-meal costs over time.

---

## Tech Stack

| Concern | Choice | Reason |
|---|---|---|
| Language | Swift 5.9+ | Native iOS, required for Xcode |
| UI Framework | SwiftUI | Modern, declarative, less boilerplate |
| Local Persistence | SwiftData (iOS 17+) | Native ORM, integrates cleanly with SwiftUI |
| Receipt OCR | Apple Vision + VisionKit | On-device, free, no API key needed |
| Camera / Photo Picker | VisionKit `DataScannerViewController` + `PhotosPicker` | Native scanning UI |
| Architecture | MVVM | Standard for SwiftUI apps |

> Minimum deployment target: **iOS 17.0** (required for SwiftData + DataScannerViewController)

---

## Data Models (SwiftData)

### `Receipt`
```swift
@Model class Receipt {
    var id: UUID
    var date: Date
    var storeName: String
    var imageData: Data?          // JPEG of receipt photo
    var rawOCRText: String        // Full text from Vision
    var lineItems: [LineItem]     // Parsed items
    var totalAmount: Double
}
```

### `LineItem`
```swift
@Model class LineItem {
    var id: UUID
    var name: String              // e.g. "Chicken Breast"
    var quantity: Double          // e.g. 2.5 (lbs)
    var unitPrice: Double
    var totalPrice: Double
    var receipt: Receipt          // back-reference
    var allocations: [Allocation] // which meals use this item
}
```

### `Meal`
```swift
@Model class Meal {
    var id: UUID
    var name: String              // e.g. "Greek Chicken Bowl"
    var emoji: String             // optional icon
    var createdAt: Date
    var allocations: [Allocation]

    // Computed
    var totalCost: Double { allocations.reduce(0) { $0 + $1.allocatedCost } }
    var costPerServing: Double { servings > 0 ? totalCost / Double(servings) : 0 }
    var servings: Int
}
```

### `Allocation`
Links a `LineItem` to a `Meal` with a fractional usage amount.
```swift
@Model class Allocation {
    var id: UUID
    var lineItem: LineItem
    var meal: Meal
    var fraction: Double          // 0.0–1.0 (e.g. 0.5 = used half the package)
    var allocatedCost: Double     // fraction * lineItem.totalPrice
}
```

---

## App Screens & Navigation

```
TabView
├── 📷  Receipts Tab
│   ├── ReceiptListView            — list of all scanned receipts
│   ├── ScanReceiptView            — camera/photo picker + OCR processing
│   ├── ReceiptDetailView          — shows parsed line items
│   └── AllocateIngredientsView    — assign each item (or portion) to a meal
│
├── 🍱  Meals Tab
│   ├── MealListView               — all meals with total cost badge
│   ├── AddMealView                — create a new meal
│   └── MealDetailView             — ingredients list, cost breakdown, cost/serving
│
└── 📊  Summary Tab
    └── SummaryView                — charts: spend by meal, spend over time, top ingredients
```

---

## Receipt Scanning Flow (Step-by-Step)

1. User taps **+** on Receipts tab → chooses Camera or Photo Library
2. `VisionKit.DataScannerViewController` (camera) **or** `PhotosPicker` (library)
3. Image passed to `ReceiptOCRService`:
   - Uses `Vision.VNRecognizeTextRequest` with `recognitionLevel: .accurate`
   - Parses lines into `(name, quantity, price)` tuples using regex + heuristics
4. `ReceiptDetailView` shows parsed items — user can:
   - Edit any item name/price (OCR is never perfect)
   - Confirm the store name & date
5. User taps **Allocate →** to enter `AllocateIngredientsView`

---

## Allocation Flow

For each `LineItem` on the receipt:
- User selects one or more meals from a searchable list (or creates a new meal inline)
- For each selected meal, sets a **fraction slider** (0–100%) or "Use All"
- App calculates `allocatedCost = fraction * totalPrice` in real time
- Unallocated remainder shown so user knows what's left unassigned
- Save writes `Allocation` records to SwiftData

---

## Key Services

### `ReceiptOCRService`
```
Input:  UIImage
Output: Receipt (populated line items, raw text)

Steps:
  1. Run VNRecognizeTextRequest
  2. Join observations into lines
  3. Regex: match price pattern  e.g. "$4.99" or "4.99"
  4. Pair price with nearest text to its left on same line
  5. Detect store name from first 3 lines
  6. Detect date using NSDataDetector
```

### `CostCalculatorService`
```
Input:  Meal
Output: totalCost, costPerServing, ingredientBreakdown[]

Logic:
  - Sum all Allocation.allocatedCost where allocation.meal == meal
  - Divide by meal.servings for per-serving cost
```

---

## File Structure (Xcode Project)

```
MealPrepTracker/
├── App/
│   └── MealPrepTrackerApp.swift   — @main, ModelContainer setup
├── Models/
│   ├── Receipt.swift
│   ├── LineItem.swift
│   ├── Meal.swift
│   └── Allocation.swift
├── ViewModels/
│   ├── ReceiptViewModel.swift
│   ├── MealViewModel.swift
│   └── SummaryViewModel.swift
├── Views/
│   ├── Receipts/
│   │   ├── ReceiptListView.swift
│   │   ├── ScanReceiptView.swift
│   │   ├── ReceiptDetailView.swift
│   │   └── AllocateIngredientsView.swift
│   ├── Meals/
│   │   ├── MealListView.swift
│   │   ├── AddMealView.swift
│   │   └── MealDetailView.swift
│   └── Summary/
│       └── SummaryView.swift
├── Services/
│   ├── ReceiptOCRService.swift
│   └── CostCalculatorService.swift
└── Resources/
    └── Assets.xcassets
```

---

## Implementation Order

1. **Xcode Project Setup** — New SwiftUI app, SwiftData enabled, iOS 17 target
2. **Data Models** — All four `@Model` classes + `ModelContainer` config
3. **Meal CRUD** — `MealListView`, `AddMealView`, `MealDetailView`
4. **Receipt Scanning** — `ReceiptOCRService` + `ScanReceiptView`
5. **Receipt Detail & Editing** — `ReceiptDetailView` with editable line items
6. **Allocation UI** — `AllocateIngredientsView` with fraction sliders
7. **Cost Calculation** — `CostCalculatorService`, update `MealDetailView`
8. **Summary / Charts** — `SummaryView` using Swift Charts
9. **Polish** — empty states, error handling, loading indicators

---

## Open Questions to Resolve Before Coding

| # | Question | Default Assumption |
|---|---|---|
| 1 | Should one ingredient be splittable across multiple meals in one receipt? | Yes — fraction-based allocation |
| 2 | Support multiple stores / currencies? | Single currency (USD), store name is freeform text |
| 3 | Should the app support iCloud sync? | No — local only for v1 |
| 4 | Do you want nutrition tracking as well? | No — cost only for v1 |
| 5 | Minimum iOS version? | iOS 17 (SwiftData) |
