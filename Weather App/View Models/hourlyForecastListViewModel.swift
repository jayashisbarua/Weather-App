//
//  ForecastListViewModel.swift
//  Mobile Weather App
//

import CoreLocation
import Foundation
import SwiftUI

class HourlyForecastListViewModel: ObservableObject {
    @Published var hourlyForecasts: [hourlyForecastViewModel] = []
    @Published var cityName: String = "Unknown City"
    @Published var errorMessage: String?

    private let locationManager = LocationManager()

    init() {
        locationManager.onLocationUpdate = { [weak self] in
            self?.getWeatherForecast()
        }
    }

    func getWeatherForecast() {
        let lat = locationManager.latitude ?? 23.25
        let lon = locationManager.longitude ?? 77.50
        
        let urlString = "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=\(lat)&lon=\(lon)&appid=a16e4487ab03d38a4fca0ed322427a07&units=metric"

        print("🌍 Fetching Hourly weather for: \(lat), \(lon)")
        print("🔗 API URL: \(urlString)")

        APIService.shared.getJSON(urlString: urlString, dateDecodingStrategy: .secondsSince1970) { (result: Result<hourlyForecast, APIService.APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecastData):
                    print("✅ Weather data received!")
                    self.hourlyForecasts = forecastData.list.map { hourlyForecastViewModel(hourlyForecast: $0) }
                case .failure(let error):
                    self.errorMessage = "❌ Error fetching data: \(error)"
                    print(self.errorMessage ?? "Unknown error")
                }
            }
        }
    }
}
