//
//  TomorrowView.swift
//  Weather App
//
//  Created by Jayashis Barua on 16/02/25.
//

import SwiftUI

struct TomorrowView: View {
    
    @StateObject private var forecastVm = ForecastListViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                topElement()
                middleElements()
                hourlyView()
            }
        }
        .padding(.top, 20)
        .scrollIndicators(.hidden)
        .foregroundStyle(.white.opacity(0.1))
    }
}

#Preview {
    TomorrowView()
}

struct topElement: View {
    
    @StateObject private var forecastVm = ForecastListViewModel()
    
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
                        if let secondDayForecast = forecastVm.forecasts.dropFirst().first {
                            HStack(alignment: .bottom) {
                                Text(secondDayForecast.temp)
                                    .foregroundStyle(.black)
                                    .font(.system(size: UIScreen.main.bounds.width * 0.2))
                                
                                Text("Feels Like \(secondDayForecast.feelsLike)")
                                    .foregroundStyle(.black)
                                    .padding(.bottom)
                            }
                            Spacer()
                            HStack(alignment: .bottom) {
                                Text("\(secondDayForecast.month)")
                                    .foregroundStyle(.black)
                                    .padding(.bottom)
                            }
                        } else {
                            Text("No Data Available")
                                .foregroundStyle(.black)
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

                        if let secondDayForecast = forecastVm.forecasts.dropFirst().first {
                            VStack(alignment: .trailing) {
                                HStack {
                                    Text("Day")
                                    Text(secondDayForecast.dayTemp)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                                HStack {
                                    Text("Night")
                                    Text(secondDayForecast.nightTemp)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                            }
                            .padding(.bottom, 12)
                            .foregroundStyle(.black)
                        }
                    }
                }
            }
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
    }
}

struct secondDayDetails: View {

    let icon: String
    let text: String
    let element: String

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: UIScreen.main.bounds.width * 0.44, height: UIScreen.main.bounds.height * 0.15)
            .overlay {
                VStack {
                    Text(text)
                        .foregroundStyle(.black)
                    
                    Image(icon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.05, height: UIScreen.main.bounds.height * 0.05)
                    
                    Text(element)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                }
            }
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
    }
}

struct hourlyView: View {
    
    @StateObject private var hourlyForecastVm = HourlyForecastListViewModel()
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: UIScreen.main.bounds.width * 0.91, height: UIScreen.main.bounds.height * 0.23)
            .overlay {
                VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.07) {
                    let calendar = Calendar.current
                    let startHour = 6
                    let startIndex = hourlyForecastVm.hourlyForecasts.firstIndex { hourlyForecast in
                        let forecastHour = Int(hourlyForecast.time.prefix(2)) ?? 0
                        return forecastHour == startHour
                    } ?? 0
                    
                    let endIndex = min(startIndex + 24, hourlyForecastVm.hourlyForecasts.count)
                    let forecastSubset = hourlyForecastVm.hourlyForecasts[startIndex..<endIndex]
                    
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
                            ForEach(forecastSubset, id: \.time) { hourlyForecast in
                                VStack(spacing: 10) {
                                    let newTime = convertTo12HourFormat(hourlyForecast.time)
                                    Text(newTime)
                                        .font(.subheadline)
                                    Image(systemName: getWeatherIcon(for: hourlyForecast.shortDescription))
                                        .renderingMode(.original)
                                        .font(.title)
                                    Text(hourlyForecast.temp)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(.black)
                            }
                        }
                    }
                }

                .padding(.horizontal)
            }
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
            .padding(.top, UIScreen.main.bounds.height * 0.01)
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

struct middleElements: View {
    
    @StateObject private var forecastVm = ForecastListViewModel()
    
    var body: some View {
        VStack {
            HStack {
                if let secondDayForecast = forecastVm.forecasts.dropFirst().first {
                    secondDayDetails(icon: "sunriseIcon", text: "Sunrise", element: secondDayForecast.sunrise)
                    secondDayDetails(icon: "sunsetIcon", text: "Sunset", element: secondDayForecast.sunset)
                }
            }
            .padding(.top, UIScreen.main.bounds.height * 0.01)
            
            HStack {
                if let secondDayForecast = forecastVm.forecasts.dropFirst().first {
                    secondDayDetails(icon: "pop", text: "Rain chance", element: secondDayForecast.pop)
                    secondDayDetails(icon: "humidity", text: "Humidity", element: secondDayForecast.humidity)
                }
            }
        }
    }
}
