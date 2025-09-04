import Foundation

extension Date {
    /// Start of the current day in the current calendar.
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }

    /// Next midnight after the receiver.
    var nextMidnight: Date {
        let calendar = Calendar.current
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return startOfTomorrow
    }
}
