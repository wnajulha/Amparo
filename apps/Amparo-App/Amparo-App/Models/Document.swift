import Foundation

struct Document: Codable, Identifiable {
    let id: String
    let name: String
    let fileUrl: String
    let mimeType: String
    let sizeBytes: Int
    let uploadedAt: Date
    let elderlyId: String

    var formattedSize: String {
        let bytes = Double(sizeBytes)
        if bytes < 1024 { return "\(sizeBytes) B" }
        if bytes < 1_048_576 { return String(format: "%.1f KB", bytes / 1024) }
        return String(format: "%.1f MB", bytes / 1_048_576)
    }
}
