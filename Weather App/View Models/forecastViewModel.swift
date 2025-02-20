import Foundation

struct ForecastViewModel {
    let forecast: List2
    
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
    
    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d" // Example: "Mon, Feb 10"
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
    
    private func convertUnixToMonth(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return Self.monthFormatter.string(from: date)
    }
    
    private func convertUnixToDay(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return Self.dayFormatter.string(from: date)
    }
    
    private func convertUnixToTime(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return Self.timeFormatter.string(from: date)
    }
    
    var date: String {
        let dateString = convertUnixToDate(forecast.dt)
        return dateString
    }
    
    var day: String {
        let dayString = convertUnixToDay(forecast.dt)
        return dayString
    }
    
    var month: String {
        let month = convertUnixToMonth(forecast.dt)
        return "\(month)"
    }
    
    var sunset: String {
        let sunsetString = convertUnixToTime(forecast.sunset)
        return sunsetString
    }
    
    var sunrise: String {
        let sunriseString = convertUnixToTime(forecast.sunrise)
        return sunriseString
    }
    
    var overview: String {
        let description = forecast.weather.first?.description ?? "N/A"
        return description.capitalized
    }
    
    var temp: String {
        let temp = forecast.temp.day
        return String(format: "%0.0f°", temp)
    }
    
    var dayTemp: String {
        let dayTemp = forecast.temp.day
        return String(format: "%0.0f°", dayTemp)
    }
    
    var nightTemp: String {
        let nightTemp = forecast.temp.day
        return String(format: "%0.0f°", nightTemp)
    }
    
    var max: String {
        let maxTemp = Int(forecast.temp.max)
        return "Max: \(maxTemp)°"
    }
    
    var min: String {
        let minTemp = Int(forecast.temp.min)
        return "Min: \(minTemp)°"
    }
    
    var pop: String {
        let popValue = Int(forecast.pop * 100)
        return "\(popValue)%"
    }
    
    var precipitation: Double {
        let precipitationValue = Double(forecast.pop) * 100
        return precipitationValue
    }
    
    var clouds: String {
        let cloudCoverage = forecast.clouds
        return "\(cloudCoverage)%"
    }

    var humidity: String {
        let humidityValue = forecast.humidity
        return "\(humidityValue)%"
    }
    
    var speed: String {
        let windSpeed = forecast.speed
        return "\(windSpeed) Km/h"
    }
    
    var pressure: String {
        let pressureValue = forecast.pressure
        return "\(pressureValue) hPa"
    }
    
    var feelsLike: String {
        let feelsLike = forecast.feelsLike.day
        return String(format: "%0.0f°", feelsLike)
    }
    
    var shortDescription: String {
        let shortDescription = forecast.weather.first?.main.rawValue ?? "N/A"
        return shortDescription
    }
}
