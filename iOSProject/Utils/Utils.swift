import Foundation

public let dateFormat = "dd/MM/yyyy HH:mm"

///Returns the weekday from a given string that is expected in the default format
func getWeekDay(date dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    let date = formatter.date(from: dateString)!
    formatter.locale = Locale(identifier: "en")
    formatter.dateFormat = "EEEE"
    let weekday = formatter.string(from: date)
    return weekday
}
