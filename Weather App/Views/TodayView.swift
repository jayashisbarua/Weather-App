import SwiftUI

struct TodayView: View {
    
    @StateObject private var forecastVm = ForecastListViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                VStack(spacing: 10) {
                    todayBigDisplay()
                        .padding(.top, 20)
                    HStack(spacing: 10) {
                        elementTop(icon: "wind", text: "Wind speed", element: forecastVm.forecasts.first?.speed ?? "N/A")
                        elementTop(icon: "pop", text: "Rain chance", element: forecastVm.forecasts.first?.pop ?? "N/A")
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.01)

                    HStack(spacing: 10) {
                        elementTop(icon: "pressure", text: "Pressure", element: forecastVm.forecasts.first?.pressure ?? "N/A")
                        elementTop(icon: "humidity", text: "Humidity", element: forecastVm.forecasts.first?.humidity ?? "N/A")
                    }
                    
                    HStack(spacing: 10) {
                        elementTop(icon: "sunriseIcon", text: "Sunrise", element: forecastVm.forecasts.first?.sunrise ?? "N/A")
                        elementTop(icon: "sunsetIcon", text: "Sunset", element: forecastVm.forecasts.first?.sunset ?? "N/A")
                    }
                }
                
                VStack {
                    hourlyTodayView()
                }
                .padding(.top, UIScreen.main.bounds.height * 0.01)
                
                VStack(spacing: UIScreen.main.bounds.height * 0.02) {
                    dailyForecast()
                    rainChance()
                }
                .padding(.top, UIScreen.main.bounds.height * 0.01)
            }
        }
        .scrollIndicators(.hidden)
        .foregroundStyle(.white.opacity(0.1))
//        .background(.blue.opacity(0.7))
    }
}

#Preview {
    TodayView()
}

// MARK: TODAY ELEMENTS

struct elementTop: View {

    let icon: String
    let text: String
    let element: String

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: UIScreen.main.bounds.width * 0.44, height: UIScreen.main.bounds.height * 0.1)
            .overlay {
                HStack {
                    Image(icon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.04, height: UIScreen.main.bounds.height * 0.04)
                        .padding(.trailing, UIScreen.main.bounds.width * 0.02)
                    VStack(alignment: .leading, spacing: 10) {
                        Text(text)
                            .font(.headline)
                        Text(element)
                            .font(.headline)
                            .fontWeight(.regular)
                    }
                    .foregroundStyle(.black)
                    .padding(.leading, 10)
                }
            }
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
    }
}

struct hourlyTodayView: View {
    
    @StateObject private var hourlyForecastVm = HourlyForecastListViewModel()
    
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short // short, medium, long, full
        return formatter.string(from: Date())
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: UIScreen.main.bounds.width * 0.91, height: UIScreen.main.bounds.height * 0.23)
            .overlay {
                VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.035) {
                    let currentTime = Date()
                    let calendar = Calendar.current
                    let currHour = calendar.component(.hour, from: currentTime)
                    
                    let startIndex = hourlyForecastVm.hourlyForecasts.firstIndex { hourlyForecast in
                        let forecastHour = Int(hourlyForecast.time.prefix(2)) ?? 0
                        return forecastHour >= currHour
                    } ?? 0
                    
                    let endIndex = startIndex + 24
                    
                    let endIndexLimited = min(endIndex, hourlyForecastVm.hourlyForecasts.count)
                    
                    let forecastSubset = hourlyForecastVm.hourlyForecasts[startIndex..<endIndexLimited]
                    
                    HStack {
                        Image("hourglassBlack")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.04, height: UIScreen.main.bounds.height * 0.04)
                        Text("Hourly forecast")
                            .font(.title2)
                            .padding(.leading, UIScreen.main.bounds.width * 0.02)
                        Spacer()
                    }
                    .padding(.leading, UIScreen.main.bounds.width * 0.02)
                    .foregroundStyle(.black)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(Array(forecastSubset.enumerated()), id: \.element.time) { index, hourlyForecast in
                                VStack(spacing: UIScreen.main.bounds.height * 0.015) {
                                    let newTime = convertTo12HourFormat(hourlyForecast.time)
                                    Text(index == 0 ? "Now" : newTime)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Image(systemName: getWeatherIcon(for: hourlyForecast.shortDescription))
                                        .renderingMode(.original)
                                        .font(.title)
                                    Text(hourlyForecast.temp)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                                .foregroundStyle(.black)
                            }
                        }
                    }
                    .frame(height: 100)
                }
                .padding(.horizontal)
            }
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
    }
    
    func convertTo12HourFormat(_ time: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h a"

        if let date = inputFormatter.date(from: time) {
            return outputFormatter.string(from: date)
        } else {
            return time
        }
    }

}

struct dailyForecast: View {
    
    @StateObject private var forecastVm = ForecastListViewModel()
    private var forecast: ForecastViewModel? {
        forecastVm.forecasts.first
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: UIScreen.main.bounds.width * 0.91, height: UIScreen.main.bounds.height * 0.23)
            .overlay {
                VStack(spacing: UIScreen.main.bounds.height * 0.04) {
                    HStack {
                        Image("dailyBlack")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.04, height: UIScreen.main.bounds.height * 0.04)
                        Text("Daily forecast")
                            .font(.title2)
                            .padding(.leading, UIScreen.main.bounds.width * 0.02)
                        Spacer()
                    }
                    .padding(.leading, UIScreen.main.bounds.width * 0.06)
                    .foregroundStyle(.black)
                    
                    HStack(spacing: UIScreen.main.bounds.width * 0.055) {
                        ForEach(forecastVm.forecasts.indices, id: \.self) {i in
                            if (i < 6) {
                                let forecast = forecastVm.forecasts[i]
                                VStack(spacing: UIScreen.main.bounds.height * 0.015) {
                                    Text(i == 0 ? "Today" : forecast.day)
                                        .foregroundStyle(.black)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Image(systemName: getWeatherIcon(for: forecast.shortDescription))
                                        .renderingMode(.original)
                                        .font(.title)
                                    Text(forecast.temp)
                                        .foregroundStyle(.black)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                    }
                }
            }
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
    }
}

struct rainChance: View {
    
    @StateObject private var forecastVm = ForecastListViewModel()
    private var forecast: ForecastViewModel? {
        forecastVm.forecasts.first
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: UIScreen.main.bounds.width * 0.91, height: UIScreen.main.bounds.height * 0.3)
            .overlay {
                VStack(spacing: UIScreen.main.bounds.height * 0.035) {
                    HStack {
                        Image("rainCircle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.04, height: UIScreen.main.bounds.height * 0.04)
                        Text("Chance of rain")
                            .font(.title2)
                            .padding(.leading, UIScreen.main.bounds.width * 0.02)
                        Spacer()
                    }
                    .padding(.leading, UIScreen.main.bounds.width * 0.06)
                    .foregroundStyle(.black)
                    
                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.01) {
                        ForEach(forecastVm.forecasts.indices, id: \.self) {i in
                            if (i < 6) {
                                let forecast = forecastVm.forecasts[i]
                                HStack {
                                    Text(i == 0 ? "Today" : "\(forecast.day)")
                                        .foregroundStyle(.black)
                                        .font(.callout)
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white.opacity(0.5))
                                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.02)
                                        .overlay {
                                            HStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)))
                                                    .frame(width: UIScreen.main.bounds.width * (forecast.precipitation*0.005), height: UIScreen.main.bounds.height * 0.02)
                                                if forecast.precipitation < 100 {
                                                    Spacer()
                                                }
                                            }
                                        }
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.black.opacity(0))
                                        .frame(width: UIScreen.main.bounds.width*0.18, height: UIScreen.main.bounds.height * 0.02)
                                        .overlay {
                                            HStack {
                                                Spacer()
                                                Text(String(format: "%0.0f%%", forecast.precipitation))
                                                    .foregroundStyle(.black)
                                                    .font(.title3)
                                                    .fontWeight(.medium)
                                                    .padding(.trailing)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding(.leading)
                }
            }
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
    }
}

struct todayBigDisplay: View {
    
    @StateObject private var forecastVm = ForecastListViewModel()
    
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: UIScreen.main.bounds.width * 0.91, height: UIScreen.main.bounds.height * 0.3)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Text(forecastVm.cityName)
                            .foregroundStyle(.black)
                            .font(.title2)
                            .padding(.top)
                        Spacer()
                        Spacer()
                        HStack(alignment: .bottom) {
                            Text(forecastVm.forecasts.first?.temp ?? "N/A")
                                .foregroundStyle(.black)
                                .font(.system(size: UIScreen.main.bounds.width * 0.18))
                            
                            Text("Feels Like \(forecastVm.forecasts.first?.feelsLike ?? "N/A")")
                                .foregroundStyle(.black)
                                .padding(.bottom)
                        }
                        Spacer()
                        HStack(alignment: .bottom) {
                            Text("\(forecastVm.forecasts.first?.month ?? "N/A"), \(currentTime)")
                                .foregroundStyle(.black)
                                .padding(.bottom)
                        }
                    }

                    VStack(alignment: .trailing) {
                        VStack {
                            Image(getWeatherBigIcon(for: forecastVm.forecasts.first?.shortDescription ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width * 0.11, height: UIScreen.main.bounds.height * 0.11)
                                .padding(.trailing, UIScreen.main.bounds.width * 0.1)
                                .padding(.top, 20)
                            Text(forecastVm.forecasts.first?.shortDescription ?? "")
                                .foregroundStyle(.black)
                                .font(.title3)
                                .padding(.trailing, UIScreen.main.bounds.width * 0.1)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Text("Day")
                                Text(forecastVm.forecasts.first?.dayTemp ?? "N/A")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                            HStack {
                                Text("Night")
                                Text(forecastVm.forecasts.first?.nightTemp ?? "N/A")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                        }
                        .padding(.bottom, 12)
                        .foregroundStyle(.black)
                    }
                }
            }
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
    }
}

func getWeatherIcon(for description: String) -> String {
    switch description {
    case "Clear":
        return "sun.max.fill"
    case "Clouds":
        return "cloud.sun.fill"
    case "Rain":
        return "cloud.sun.rain.fill"
    default:
        return "questionmark"
    }
}

func getWeatherBigIcon(for description: String) -> String {
    switch description {
    case "Clear":
        return "clear"
    case "Clouds":
        return "cloudy"
    case "Rain":
        return "rainIcon"
    default:
        return "questionmark"
    }
}
