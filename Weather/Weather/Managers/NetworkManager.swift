//
//  NetworkManager.swift
//  Weather
//
//  Created by Сергей Киров on 21.07.2023.
//

import CoreLocation
import Foundation

final class NetworkManager {
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> WeatherModel {
        
        //&date={date}
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=3aeed4a933ac2ceb37d366abaafdeb1b&units=metric") else { fatalError("Missing URL.")}
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data.")}
        let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
        return decodedData
    }
}
