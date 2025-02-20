import SwiftUI

struct SevenDaysView: View {
    @State private var expandedItems: Set<Int> = []
    @StateObject private var forecastVm = ForecastListViewModel()

    var body: some View {
        VStack {
            if forecastVm.forecasts.isEmpty {
                ProgressView("Loading Weather Data...")
                    .padding()
            } else {
                ScrollView {
                    ForEach(forecastVm.forecasts.indices, id: \.self) { index in
                        let forecast = forecastVm.forecasts[index]
                        
                        WeatherRow(forecast: forecast, isExpanded: expandedItems.contains(index), i: index)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    if expandedItems.contains(index) {
                                        expandedItems.remove(index)
                                    } else {
                                        expandedItems.insert(index)
                                    }
                                }
                            }
                        
                        if expandedItems.contains(index) {
                            sevenDaysDetails(forecast: forecast)   // uncomment this
//                            sevenDaysDetails()         // cut this
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(.top, 20)
//        .background(.blue.opacity(1))
    }
}

struct WeatherRow: View {
    let forecast: ForecastViewModel
    let isExpanded: Bool
    let i: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.white.opacity(0.1))
            .frame(width: UIScreen.main.bounds.width * 0.91, height: UIScreen.main.bounds.height / 8.5)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Text(i == 0 ? "Today" : forecast.date)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(forecast.overview)
                            .fontWeight(.regular)
                    }
                    .padding(.leading, 20)
                    Spacer()
                    VStack {
                        Text(forecast.max)
                        Text(forecast.min)
                    }
                    .font(.subheadline)
                    .padding(.top, 2)
                    Text("|")
                        .font(.system(size: UIScreen.main.bounds.width * 0.12))
                        .fontWeight(.ultraLight)
                        .padding(.bottom, 5)
                    Image(systemName: getWeatherIcon(for: forecast.shortDescription))
                        .renderingMode(.original)
                        .font(.title)
                    VStack {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.system(size: UIScreen.main.bounds.width * 0.037))
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        Spacer()
                    }
                    .padding(.trailing, 15)
                    .padding(.top)
                }
            }
            .background(.ultraThinMaterial.opacity(0.7))
            .cornerRadius(20)
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        SevenDaysView()
    }
}
