//
//  LocationManager.swift
//  Weather
//
//  Created by Сергей Киров on 21.07.2023.
//

import CoreLocation


final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestAlwaysAuthorization()
        
    }
    
    func locationManager (
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            self.location = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
}
