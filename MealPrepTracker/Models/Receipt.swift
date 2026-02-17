import Foundation

struct Receipt: Identifiable, Codable {
    var id = UUID()
    var date = Date()
    var storeName = ""
    var imageData: Data?
    var rawOCRText = ""
    var totalAmount = 0.0
    var lineItems: [LineItem] = []
}
