//
//  ForecastListViewModel.swift
//  Mobile Weather App
//
//  Created by Stewart Lynch on 2021-01-21.
//

import CoreLocation
import Foundation
import SwiftUI


class LocateByName: ObservableObject {
    @Published var forecasts: [ForecastViewModel] = []
    @Published var location: String = "" {
        didSet {
            if !location.isEmpty {
                getWeatherForecast2(location: location)
            }
        }
    }
    
    init() {
        // Optionally fetch weather for a default location
        location = "Delhi"  // You can set an initial value
    }
    
    func getWeatherForecast2(location: String) {
        let apiService = newAPI.shared
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location, completionHandler: { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first,
                  let coordinate = placemark.location?.coordinate else {
                print("No valid coordinates found.")
                return
            }

            let lat = coordinate.latitude
            let lon = coordinate.longitude
            print(lat, lon)
            
            let urlString = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(lon)&cnt=7&appid=a16e4487ab03d38a4fca0ed322427a07&units=metric"
            
            apiService.getJSON(urlString: urlString, dateDecodingStrategy: .secondsSince1970) { (result: Result<forecast, newAPI.APIError>) in
                switch result {
                case .success(let forecast):
                    DispatchQueue.main.async {
                        self.forecasts = forecast.list.map { ForecastViewModel(forecast: $0) }
                    }
                case .failure(let apiError):
                    print("API Error: \(apiError.localizedDescription)")
                }
            }
        })
    }
}

