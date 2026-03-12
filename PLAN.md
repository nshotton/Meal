# Meal Prep Cost Tracker — Web App Implementation Plan

## Overview
A mobile-first web app that lets users photograph grocery receipts, assign ingredients to specific meals,
store leftover/partial ingredients in a pantry, and accurately calculate per-meal costs
over time — including the cost of pantry items drawn from previous purchases.

**Built as a PWA (Progressive Web App) optimized for iPhone and mobile devices.**

---

## Tech Stack

| Concern | Choice | Reason |
|---|---|---|
| Frontend | React + TypeScript | Modern, component-based, excellent ecosystem |
| Build Tool | Vite | Fast development, optimized builds |
| Styling | Tailwind CSS | Mobile-first, utility-based, rapid development |
| Routing | React Router | Standard routing for React apps |
| Backend | Node.js + Express | Fast API development, JavaScript everywhere |
| Database | PostgreSQL | Robust relational database, free & open source |
| ORM | Prisma | Type-safe database access, great DX |
| PWA | Manifest + Service Worker | Installable on iPhone, works offline |
| Receipt OCR | Tesseract.js / Google Vision API | Client or server-side OCR options |
| File Upload | Multer | Handle receipt image uploads |

> **Platform**: Works on any device with a modern browser, optimized for iPhone Safari

---

## Data Models (Prisma Schema)

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
Represents a single item on a receipt.
```swift
@Model class LineItem {
    var id: UUID
    var name: String              // e.g. "Mayonnaise"
    var quantity: Double          // e.g. 1 (jar)
    var unit: String              // e.g. "jar", "lbs", "oz", "count"
    var unitPrice: Double
    var totalPrice: Double
    var receipt: Receipt
    var mealAllocations: [MealAllocation]
    var pantryContribution: PantryItem?   // the pantry entry created from leftovers
}
```

### `Meal`
```swift
@Model class Meal {
    var id: UUID
    var name: String              // e.g. "Greek Chicken Bowl"
    var emoji: String
    var servings: Int
    var createdAt: Date
    var mealAllocations: [MealAllocation]     // from receipts
    var pantryAllocations: [PantryAllocation] // drawn from pantry

    // Computed
    var totalCost: Double {
        let fromReceipts = mealAllocations.reduce(0) { $0 + $1.allocatedCost }
        let fromPantry   = pantryAllocations.reduce(0) { $0 + $1.allocatedCost }
        return fromReceipts + fromPantry
    }
    var costPerServing: Double { servings > 0 ? totalCost / Double(servings) : 0 }
}
```

### `MealAllocation`
Links a fresh `LineItem` (from the current receipt) to a meal.
```swift
@Model class MealAllocation {
    var id: UUID
    var lineItem: LineItem
    var meal: Meal
    var fraction: Double          // 0.0–1.0 portion of the line item used
    var allocatedCost: Double     // fraction * lineItem.totalPrice
}
```

### `PantryItem`
Represents an ingredient stored for future use. Created automatically when a
`LineItem` is only partially allocated to meals — the surplus fraction becomes a
pantry entry. Can also be created manually for staple items.
```swift
@Model class PantryItem {
    var id: UUID
    var name: String              // "Mayonnaise"
    var unit: String              // "jar", "oz", "lbs", "count"

    var totalQuantity: Double     // original full amount, e.g. 1.0 (jar)
    var remainingQuantity: Double // decreases as pantry is consumed

    var totalCost: Double         // full original purchase price
    var remainingCost: Double     // proportional: remainingQuantity/totalQuantity * totalCost

    var purchaseDate: Date
    var sourceLineItem: LineItem? // nil if manually added

    var pantryAllocations: [PantryAllocation]

    // Computed
    var remainingFraction: Double { totalQuantity > 0 ? remainingQuantity / totalQuantity : 0 }
    var isEmpty: Bool { remainingQuantity <= 0 }
}
```

### `PantryAllocation`
Records when a pantry item is drawn upon for a meal.
```swift
@Model class PantryAllocation {
    var id: UUID
    var pantryItem: PantryItem
    var meal: Meal
    var quantityUsed: Double       // absolute amount consumed
    var allocatedCost: Double      // proportional cost at time of use
    var date: Date
}
```

---

## Key Concept: Cost Tracking Through the Pantry

When you buy a **$4.00 jar of mayonnaise**:

| Step | Action | Result |
|---|---|---|
| Scan receipt | LineItem: Mayo $4.00 | |
| Allocate 50% to "Chicken Salad" | MealAllocation (fraction=0.5, cost=$2.00) | Meal costs $2.00 |
| Send remaining 50% to pantry | PantryItem created (remaining=0.5 jar, remainingCost=$2.00) | |
| Later: use 25% of original jar for "Tuna Melt" | PantryAllocation (qty=0.25 jar, cost=$1.00) | Meal costs $1.00, pantry now has 0.25 jar ($1.00) left |

Every dollar is accounted for across every meal.

---

## App Screens & Navigation

```
TabView
├── 📷  Receipts Tab
│   ├── ReceiptListView              — list of all scanned receipts
│   ├── ScanReceiptView              — camera/photo picker + OCR processing
│   ├── ReceiptDetailView            — editable parsed line items
│   └── AllocateIngredientsView      — assign each item (or fraction) to meals
│                                      remaining fraction → send to pantry
│
├── 🍱  Meals Tab
│   ├── MealListView                 — all meals with total cost + cost/serving badge
│   ├── AddMealView                  — create a new meal
│   └── MealDetailView               — ingredients (receipt + pantry), full cost breakdown
│
├── 🥫  Pantry Tab
│   ├── PantryListView               — all pantry items with remaining % bar
│   ├── PantryItemDetailView         — history of how item was used across meals
│   └── AddManualPantryItemView      — add a staple (e.g. olive oil) without a receipt
│
└── 📊  Summary Tab
    └── SummaryView                  — spend by meal, spend over time, pantry value at hand
```

---

## Receipt Scanning Flow

1. User taps **+** on Receipts tab → Camera or Photo Library
2. `VisionKit.DataScannerViewController` (live camera) **or** `PhotosPicker` (library)
3. Image → `ReceiptOCRService`:
   - `VNRecognizeTextRequest` with `recognitionLevel: .accurate`
   - Regex parses lines into `(name, quantity, unit, price)` tuples
   - Detects store name from first 3 lines, date via `NSDataDetector`
4. `ReceiptDetailView` — user corrects OCR errors, confirms items
5. **Allocate →** enters `AllocateIngredientsView`

---

## Allocation Flow (Updated)

For each `LineItem`:
- **Meal sliders**: assign named fractions to one or more meals
- **Send to Pantry**: remaining unallocated fraction → creates/updates a `PantryItem`
- Live running total shows: `Allocated to meals + To pantry = 100%`
- User can split one item across 3 meals + pantry simultaneously

When using pantry items in a meal (from `MealDetailView` or `AddMealView`):
- Browse `PantryListView` inline
- Select item, set quantity used (slider or numeric entry)
- Creates `PantryAllocation`, decrements `PantryItem.remainingQuantity`
- `allocatedCost` = `(quantityUsed / totalQuantity) * totalCost`

---

## Key Services

### `ReceiptOCRService`
```
Input:  UIImage
Output: Receipt (populated line items, raw text)

Steps:
  1. VNRecognizeTextRequest (accurate mode)
  2. Join observations into lines sorted by Y position
  3. Regex match price pattern: "$4.99" / "4.99" at end of line
  4. Extract item name as text left of price on same line
  5. Attempt to parse quantity + unit (e.g. "2 lbs", "16 oz")
  6. Detect store name from header lines
  7. Detect date via NSDataDetector
```

### `PantryService`
```
createPantryItem(from lineItem: LineItem, fraction: Double) -> PantryItem
usePantryItem(_ item: PantryItem, quantity: Double, for meal: Meal) -> PantryAllocation
```

### `CostCalculatorService`
```
totalCost(for meal: Meal) -> Double
costPerServing(for meal: Meal) -> Double
ingredientBreakdown(for meal: Meal) -> [(name: String, cost: Double, source: IngredientSource)]
pantryValue() -> Double    // total remaining cost stored in pantry
```

---

## File Structure (Xcode Project)

```
MealPrepTracker/
├── App/
│   └── MealPrepTrackerApp.swift
├── Models/
│   ├── Receipt.swift
│   ├── LineItem.swift
│   ├── Meal.swift
│   ├── MealAllocation.swift
│   ├── PantryItem.swift
│   └── PantryAllocation.swift
├── ViewModels/
│   ├── ReceiptViewModel.swift
│   ├── MealViewModel.swift
│   ├── PantryViewModel.swift
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
│   ├── Pantry/
│   │   ├── PantryListView.swift
│   │   ├── PantryItemDetailView.swift
│   │   └── AddManualPantryItemView.swift
│   └── Summary/
│       └── SummaryView.swift
├── Services/
│   ├── ReceiptOCRService.swift
│   ├── PantryService.swift
│   └── CostCalculatorService.swift
└── Resources/
    └── Assets.xcassets
```

---

## Implementation Order

1. **Xcode Project Setup** — SwiftUI app, SwiftData, iOS 17 target, 4-tab structure
2. **Data Models** — All 6 `@Model` classes + `ModelContainer`
3. **Meal CRUD** — `MealListView`, `AddMealView`, `MealDetailView`
4. **Receipt Scanning** — `ReceiptOCRService` + `ScanReceiptView`
5. **Receipt Detail & Editing** — `ReceiptDetailView` with editable line items
6. **Allocation UI** — `AllocateIngredientsView` — meal fractions + pantry surplus
7. **Pantry Views** — `PantryListView`, `PantryItemDetailView`, `AddManualPantryItemView`
8. **Pantry → Meal Usage** — draw pantry items into meals, `PantryService`
9. **Cost Calculation** — `CostCalculatorService`, full cost display in `MealDetailView`
10. **Summary / Charts** — `SummaryView` using Swift Charts
11. **Polish** — empty states, low-pantry warnings, error handling, loading states

---

## Confirmed Decisions

- Ingredients are **splittable** across multiple meals (fraction sliders)
- Leftover fractions are sent to the **pantry** with full cost-basis tracking
- Pantry items can be **manually added** (for staples not from a scanned receipt)
- Pantry items are **depleted** as they are used in meals, cost is tracked proportionally
- **Local only** — no iCloud sync in v1
- **Cost only** — no nutrition tracking in v1
- **Single currency** (USD), freeform store names
- **iOS 17** minimum deployment target
