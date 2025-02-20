//
//  sevenDaysDetails.swift
//  Weather App
//
//  Created by Jayashis Barua on 15/02/25.
//

import SwiftUI

struct sevenDaysDetails: View {
//    @StateObject private var forecastVm = ForecastListViewModel()
    let forecast: ForecastViewModel           // uncomment
    
    var body: some View {
        ZStack {
//            Color.blue.opacity(0.5)
//                .ignoresSafeArea()
//            let forecast = forecastVm.forecasts.first       // cut
            VStack(alignment: .leading) {
                HStack {
//                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.02) {                // cut
//                        VStack(alignment: .leading) {
//                            Text("Day: ")
//                                .foregroundStyle(.secondary)
//                                .font(.callout)
//                            elements(pic: "sun", value: "  \(forecast?.dayTemp ?? "N/A")")
//                        }
//                        VStack(alignment: .leading) {
//                            Text("Precipetation: ")
//                                .foregroundStyle(.secondary)
//                                .font(.callout)
//                            elements2(pic: "pop", value: forecast?.precipitation ?? 0)
//                        }
//                    }
//                    Spacer()
//                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.02) {
//                        VStack(alignment: .leading) {
//                            Text("Night: ")
//                                .foregroundStyle(.secondary)
//                                .font(.callout)
//                            elements(pic: "moon", value: "  \(forecast?.nightTemp ?? "N/A")")
//                        }
//                        VStack(alignment: .leading) {
//                            Text("Humidity: ")
//                                .foregroundStyle(.secondary)
//                                .font(.callout)
//                            elements(pic: "humidity", value: "  \(forecast?.humidity ?? "N/A")")
//                        }
//                    }
                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.02) {
                        VStack(alignment: .leading) {
                            Text("Day")
                                .foregroundStyle(.secondary)
                                .font(.callout)
                                .fontWeight(.semibold)
                            elements(pic: "sun", value: "  \(forecast.dayTemp)")
                        }
                        VStack(alignment: .leading) {
                            Text("Precipetation")
                                .foregroundStyle(.secondary)
                                .font(.callout)
                                .fontWeight(.semibold)
                            elements2(pic: "pop", value: forecast.precipitation)
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.02) {
                        VStack(alignment: .leading) {
                            Text("Night")
                                .foregroundStyle(.secondary)
                                .font(.callout)
                                .fontWeight(.semibold)
                            elements(pic: "moon", value: "  \(forecast.nightTemp)")
                        }
                        VStack(alignment: .leading) {
                            Text("Humidity")
                                .foregroundStyle(.secondary)
                                .font(.callout)
                                .fontWeight(.semibold)
                            elements(pic: "humidity", value: "  \(forecast.humidity)")
                        }
                    }
                    .padding(.trailing)
                }
            }
            .padding(.leading, 10)
            .padding()
            .frame(maxWidth: UIScreen.main.bounds.width * 0.91)
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
        }
    }
}

#Preview {
//    sevenDaysDetails()
}

struct elements: View {
    
    @StateObject var forecast = ForecastListViewModel()
    let pic: String
    let value: String
    
    var body: some View {
        HStack {
            Image(pic)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width*0.04, height: UIScreen.main.bounds.height*0.04)
                .font(.headline)
                .padding(.leading, 6)
            Text(value)
                .font(.title3)
        }
    }
}

struct elements2: View {
    
    @StateObject var forecast = ForecastListViewModel()
    let pic: String
    let value: Double
    
    var body: some View {
        HStack {
            Image(pic)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width*0.04, height: UIScreen.main.bounds.height*0.04)
                .padding(.leading)
            Text(String(format: "   %0.0f%%", value))
                .font(.title3)
                .padding(.bottom, 10)
        }
    }
}
