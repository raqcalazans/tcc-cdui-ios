import Foundation

enum FanBirthDateFormatter {
    static func display(_ value: String) -> String {
        transform(value, from: "yyyy-MM-dd", to: "dd/MM/yyyy") ?? value
    }

    static func storage(_ value: String) -> String {
        transform(value, from: "dd/MM/yyyy", to: "yyyy-MM-dd") ?? value
    }

    static func age(from value: String, asOf date: Date = Date()) -> Int? {
        let formatter = makeFormatter(format: "yyyy-MM-dd", timeZone: .current)
        guard let birthDate = formatter.date(from: value), formatter.string(from: birthDate) == value else { return nil }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        guard let age = calendar.dateComponents([.year], from: birthDate, to: date).year, age >= 0 else { return nil }
        return age
    }

    private static func transform(_ value: String, from inputFormat: String, to outputFormat: String) -> String? {
        let inputFormatter = makeFormatter(format: inputFormat)
        guard let date = inputFormatter.date(from: value), inputFormatter.string(from: date) == value else { return nil }
        return makeFormatter(format: outputFormat).string(from: date)
    }

    private static func makeFormatter(format: String, timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .current) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = timeZone
        formatter.isLenient = false
        formatter.dateFormat = format
        return formatter
    }
}
