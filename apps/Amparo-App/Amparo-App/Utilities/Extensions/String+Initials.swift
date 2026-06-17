import Foundation

extension String {
    var initials: String {
        let words = self.split(separator: " ").prefix(2)
        return words.compactMap { $0.first }.map { String($0) }.joined().uppercased()
    }
}
