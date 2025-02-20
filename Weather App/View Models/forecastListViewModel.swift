//
//  ForecastListViewModel.swift
//  Mobile Weather App
//

import CoreLocation
import Foundation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var errorMessage: String?
    
    var onLocationUpdate: (() -> Void)?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let newLatitude = location.coordinate.latitude
        let newLongitude = location.coordinate.longitude
        
        if latitude != newLatitude || longitude != newLongitude {
            DispatchQueue.main.async {
                self.latitude = newLatitude
                self.longitude = newLongitude
                print("📍 Location updated: \(self.latitude!), \(self.longitude!)")
                self.onLocationUpdate?()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "⚠️ Failed to get location: \(error.localizedDescription)"
            print(self.errorMessage ?? "Unknown location error")
        }
    }
}

class ForecastListViewModel: ObservableObject {
    @Published var forecasts: [ForecastViewModel] = []
    @Published var cityName: String = "Unknown City"
    @Published var errorMessage: String?

    private let locationManager = LocationManager()
    private var lastFetchedLatitude: Double?
    private var lastFetchedLongitude: Double?
    private var hasFetchedWeather = false  // ✅ Added flag to prevent duplicate API calls

    init() {
        locationManager.onLocationUpdate = { [weak self] in
            self?.fetchWeatherIfNeeded()
        }
    }

    private func fetchWeatherIfNeeded() {
        guard let lat = locationManager.latitude, let lon = locationManager.longitude else { return }

        // ✅ Prevent repeated API calls by checking if the location has changed
        if hasFetchedWeather && lat == lastFetchedLatitude && lon == lastFetchedLongitude {
            print("⚠️ Weather data already fetched for this location. Skipping API call.")
            return
        }

        // ✅ Update stored location to prevent duplicate calls
        lastFetchedLatitude = lat
        lastFetchedLongitude = lon
        hasFetchedWeather = true

        getWeatherForecast(lat: lat, lon: lon)
    }

    func getWeatherForecast(lat: Double, lon: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(lon)&cnt=7&appid=a16e4487ab03d38a4fca0ed322427a07&units=metric"

        print("🌍 Fetching weather for: \(lat), \(lon)")
        print("🔗 API URL: \(urlString)")

        APIService.shared.getJSON(urlString: urlString, dateDecodingStrategy: .secondsSince1970) { (result: Result<forecast, APIService.APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecastData):
                    print("✅ Weather data received!")
                    self.forecasts = forecastData.list.map { ForecastViewModel(forecast: $0) }
                    self.cityName = forecastData.city.name
                    print("🏙 City Name: \(self.cityName)")
                case .failure(let error):
                    self.errorMessage = "❌ Error fetching data: \(error)"
                    print(self.errorMessage ?? "Unknown error")
                }
            }
        }
    }
}


