import Foundation

extension Date {
    var dayMonthYear: String {
        formatted(.dateTime.day().month(.wide).year())
    }

    var shortWeekdayDay: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEE, d MMM"
        return formatter.string(from: self).uppercased()
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }

    var iso8601String: String {
        ISO8601DateFormatter().string(from: self)
    }
}
