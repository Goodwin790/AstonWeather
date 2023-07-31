//
//  ViewModel.swift
//  Weather
//
//  Created by Сергей Киров on 21.07.2023.
//

import Combine
import Foundation

enum ViewStates {
    case loading
    case success
    case failed
    case none
}

final class ViewModel: ObservableObject {
    private var locationManager = LocationManager()
    private var networkManager = NetworkManager()
    @Published var weather: WeatherModel?
    @Published var state: ViewStates = .none
    
    
    func getWeather() {
        print("Getting location...")
        if let location = locationManager.location {
            print("Location getted")
            state = .loading
            Task {
                do {
                    print("Start get weather")
                   weather =  try await networkManager.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    state = .success
                    print("End get weather")
                } catch {
                    state = .failed
                    print("Error getting weather: \(error)")
                }
            }
        } else {
            print("Not geo")
        }
    }
    
    func getStatusImage() -> String {
        switch weather?.weather.first?.main {
        case "Sunny":
            return "sun.max"
        case "Clouds":
            return "cloud"
        case "Rain":
            return "cloud.heavyrain"
        default:
            return "arrow.clockwise.icloud"
        }
    }
    
    func getTemperature() -> String {
        guard let temperature = weather?.main.temp else { return "Failed to determine the temperature." }
        return String(temperature)
    }
    
    func getCity() -> String {
        guard let weather =  weather?.name else { return "Failed to determine the city."}
       return weather
    }
}
