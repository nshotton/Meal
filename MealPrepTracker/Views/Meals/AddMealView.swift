import SwiftUI

struct AddMealView: View {
    @EnvironmentObject private var store: DataStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedEmoji = "🍱"
    @State private var servings = 2

    private let suggestedEmojis = [
        "🍱", "🥘", "🍲", "🥗", "🍜", "🍝",
        "🍛", "🌮", "🌯", "🥙", "🍔", "🥪",
        "🍳", "🥞", "🍗", "🥩", "🫕", "🫔"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section("Meal Name") {
                    TextField("e.g. Greek Chicken Bowl", text: $name)
                        .autocorrectionDisabled()
                }

                Section("Emoji") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(suggestedEmojis, id: \.self) { emoji in
                                Text(emoji)
                                    .font(.title)
                                    .padding(8)
                                    .background(
                                        selectedEmoji == emoji
                                            ? Color.accentColor.opacity(0.2)
                                            : Color.clear
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture { selectedEmoji = emoji }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Servings") {
                    Stepper(
                        "\(servings) serving\(servings == 1 ? "" : "s")",
                        value: $servings,
                        in: 1...50
                    )
                }
            }
            .navigationTitle("New Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        var meal = Meal()
        meal.name = name.trimmingCharacters(in: .whitespaces)
        meal.emoji = selectedEmoji
        meal.servings = servings
        store.addMeal(meal)
        dismiss()
    }
}
