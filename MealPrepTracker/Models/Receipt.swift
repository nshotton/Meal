import Foundation
import SwiftData

@Model
final class Receipt {
    var id: UUID
    var date: Date
    var storeName: String
    var imageData: Data?
    var rawOCRText: String
    var totalAmount: Double

    @Relationship(deleteRule: .cascade)
    var lineItems: [LineItem] = []

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        storeName: String,
        imageData: Data? = nil,
        rawOCRText: String = "",
        totalAmount: Double = 0
    ) {
        self.id = id
        self.date = date
        self.storeName = storeName
        self.imageData = imageData
        self.rawOCRText = rawOCRText
        self.totalAmount = totalAmount
    }
}
