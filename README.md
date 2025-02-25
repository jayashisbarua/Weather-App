# 🌦️ Weather App    

**Weather App** is a beautifully designed **SwiftUI** application that provides real-time weather updates, a **7-day forecast**, and **dynamic backgrounds** that change based on the time of day. Built using the **MVVM** architecture and the **OpenWeather API**, this app delivers an elegant and smooth user experience with interactive UI elements and animations.  

---

## 🚀 Features  

### ✅ **Live Weather Data**  
- Fetches real-time weather conditions for any location using the **OpenWeather API**.  
- Displays **temperature, weather descriptions, and min/max temperature**.

- ### ✅ **Tomorrow Forecast**  
- Shows an extended weather forecast for the next day 

### ✅ **7-Day Forecast**  
- Shows an extended weather forecast for the upcoming week.  
- Click on any day to expand and view additional details.  

### ✅ **Dynamic UI & Animations**  
- Background images **change dynamically** based on the time of day (morning, afternoon, night, etc.).  
- **Smooth animations** for expanding and collapsing daily forecast rows.  

### ✅ **Optimized API Handling**  
- Uses `@ObservedObject` and `@StateObject` to **prevent unnecessary API calls**.  
- Implements **loading states** with `ProgressView` for better user experience.  

---

## 📸 Screenshots  

| Current Weather | Tomorrow | 7-Day Forecast |
|---|---|---|
| ![Screenshot1](https://github.com/jayashisbarua/Weather-App/blob/main/noon.png) | ![Screenshot2](https://github.com/jayashisbarua/Weather-App/blob/main/tomorrow.png) | ![Screenshot3](https://github.com/jayashisbarua/Weather-App/blob/main/7-Days-View.png) |  

## 📱 UI Screenshots
| Sunrise | Early Morning | Morning | Afternoon |
|---|---|---|---|
| ![Screenshot1](https://github.com/jayashisbarua/Weather-App/blob/main/sunrise.png) | ![Screenshot2](https://github.com/jayashisbarua/Weather-App/blob/main/early%20Morning.png) | ![Screenshot3](https://github.com/jayashisbarua/Weather-App/blob/main/morning.png) | ![Screenshot4](https://github.com/jayashisbarua/Weather-App/blob/main/noon.png) |

| Sunset | Early Night | Night | Midnight |
|---|---|---|---|
![Screenshot5](https://github.com/jayashisbarua/Weather-App/blob/main/sunset.png) | ![Screenshot6](https://github.com/jayashisbarua/Weather-App/blob/main/early%20night.png) | ![Screenshot7](https://github.com/jayashisbarua/Weather-App/blob/main/night.png) | ![Screenshot8](https://github.com/jayashisbarua/Weather-App/blob/main/midnight.png) |
---

## 🛠️ Tech Stack  

The Weather App is built using modern Apple technologies and best practices:  

### **Frontend**  
- **SwiftUI** – A declarative framework for building beautiful UIs.  
- **Combine** – For handling reactive programming and real-time data updates.  
- **CoreLocation** – (Planned) Fetch user’s current location automatically.  

### **Backend**  
- **OpenWeather API** – Fetches real-time weather data.  

### **Architecture**  
- **MVVM (Model-View-ViewModel)** – Ensures clean separation of concerns.  
- Uses `@StateObject` and `@ObservedObject` for efficient state management.  

---

### 4️⃣ **Run the App**  
- Select a **simulator or connected device**.  
- Click **Run** ▶️ in Xcode.  
- Enjoy real-time weather updates! 🌤️  

---

## 📌 To-Do List  

These are planned enhancements for future versions:  

✅ **Fix redundant API calls** (Implemented)  
✅ **Smooth animations for row expansion** (Implemented)  
🔲 **Search Location Detection** – Use CoreLocation to get any location's weather forecast given by user.  
🔲 **Temperature Unit Toggle** – Switch between Celsius and Fahrenheit.  
🔲 **Weather Widgets** – Show quick weather updates on the home screen.  
🔲 **Dark Mode Support** – Add dark mode UI themes.  
🔲 **Apple Watch & iPad Support** – Optimize the UI for different Apple devices.  

---

## 📩 Contact  

For questions or feature requests, feel free to reach out:  

📧 Email: **jayashisbarua2006@gmail.com**  
🧑🏻‍💼 Linkedin: [@jayashisbarua](https://www.linkedin.com/in/jayashisBarua/)  
📌 GitHub: [jayashisbarua](https://github.com/jayashisbarua)  

---
