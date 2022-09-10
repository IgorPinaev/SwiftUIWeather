//
//  LocationService.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 25.08.2022.
//

import Foundation
import CoreLocation

final class LocationService: NSObject {
    
    @Published private (set) var currentCityName: String?
    @Published private (set) var authorizationStatus: CLAuthorizationStatus?
    @Published private (set) var location: CLLocation?
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 100
    }
    
    func start() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

private extension LocationService {
    
    func setCityName(from location: CLLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first,
                  let cityName = placemark.locality
            else { return }
            
            self?.currentCityName = cityName
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        setCityName(from: location)
    }
}
