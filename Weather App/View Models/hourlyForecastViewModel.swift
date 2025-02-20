import Foundation

struct hourlyForecastViewModel {
    let hourlyForecast: hours
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d" // Example: "Mon, Feb 10"
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private func convertUnixToDate(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return Self.dateFormatter.string(from: date)
    }
    
    private func convertUnixToDay(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return Self.dayFormatter.string(from: date)
    }
    
    private func convertUnixToTime(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return Self.timeFormatter.string(from: date)
    }
    
    var time: String {
        let str = hourlyForecast.dtTxt
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = inputFormatter.date(from: str) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm" // 12-hour format with AM/PM
            
            let time = outputFormatter.string(from: date)
            return time
        }
        return "N/A"
    }
    
    var temp: String {
        let temp = hourlyForecast.main.temp
        return String(format: "%0.0f°", temp)
    }
    
    var shortDescription: String {
        let shortDescription = hourlyForecast.weather.first?.main.rawValue ?? "N/A"
        return shortDescription
    }
}
