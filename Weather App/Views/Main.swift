import SwiftUI

struct Main: View {
    
    @StateObject private var forecastVm = ForecastListViewModel()
    @StateObject private var hourlyForecastVm = HourlyForecastListViewModel()
    @StateObject private var locationManager = LocationManager()
    
    @State var location: String = ""
    @State private var selectedIndex = 0
    
    let screens: [AnyView] = [
        AnyView(TodayView()),
        AnyView(TomorrowView()),
        AnyView(SevenDaysView())
    ]
    
    var currentHour: Int {
        Calendar.current.component(.hour, from: Date())
    }
    
    @ViewBuilder
    var backgroundView: some View {
        if currentHour >= 4 && currentHour <= 6 {
            Image("sunrise1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else if currentHour >= 7 && currentHour <= 8 {
            Image("morning1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else if currentHour >= 9 && currentHour <= 11 {
            Image("sky")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else if currentHour >= 12 && currentHour <= 16 {
            Image("noon3")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else if currentHour >= 17 && currentHour <= 18 {
            Image("sunset")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else if currentHour >= 19 && currentHour <= 20 {
            Image("lightnight2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else if currentHour >= 21 && currentHour <= 23 {
            Image("night")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else if currentHour <= 3 {
            Image("night1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
    
    var backgroundColor: Color {
        switch currentHour {
        case 4...6: return Color(#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))         // Sunrise - Orange tint
        case 7...8: return Color(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1))         // Morning - Yellowish tint
        case 9...11: return Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1))        // Daylight - Light blue
        case 12...16: return Color(#colorLiteral(red: 0, green: 0.09691794962, blue: 0.3161595166, alpha: 1))       // Noon - Neutral white
        case 17...18: return Color(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))       // Sunset - Dark orange
        case 19...20: return Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))       // Early night - Light purple
        case 21...23: return Color(#colorLiteral(red: 0.1721295714, green: 0.5022031665, blue: 0.6429432631, alpha: 1))       // Night - Darker purple
        case 0...3: return Color(#colorLiteral(red: 0.1483051777, green: 0.4396276474, blue: 0.6298770308, alpha: 1))         // Midnight - Dark black
        default: return Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1))            // Fallback to white
        }
    }
    
    var searchNavigation: some View {
        VStack(spacing: 10) {
            Text("😢")
            Text("Coming Soon...")
        }
        .font(.system(size: UIScreen.main.bounds.width / 10))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(backgroundView)
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter location here...", text: $location)
                        .padding()
                        .foregroundStyle(.primary)
                        .background(.white.opacity(0.2))
                        .background(.thinMaterial)
                        .cornerRadius(10)
                    
                    NavigationLink {
                        searchNavigation
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: UIScreen.main.bounds.width * 0.1))
                            .foregroundStyle(backgroundColor)
                    }
//                    Text("\(currentHour)")
                }
                .padding()
                
                HStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedIndex == index ? backgroundColor : Color.white.opacity(0.7))
                            .frame(width: UIScreen.main.bounds.width / 3.3, height: UIScreen.main.bounds.height / 17)
                            .overlay {
                                Text(index == 0 ? "Today" : index == 1 ? "Tomorrow" : "7 Days")
                                    .foregroundStyle(selectedIndex == index ? Color.white : Color.primary)
                            }
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = index
                                }
                            }
                            .background(.thickMaterial)
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
                
                TabView(selection: $selectedIndex) {
                    ForEach(0..<3, id: \.self) { index in
                        screens[index]
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: selectedIndex)
            }
            .background(backgroundView)
        }
    }
}

#Preview {
    Main()
}
